#! /usr/bin/env uv run
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "whisper-mps>=0.0.10",
#     "yt-dlp>=2026.2.4",
# ]
# ///
"""
Download YouTube -> MP4, convert -> MP3, transcribe -> text (via whisper-mps).

Requirements:
  - brew install ffmpeg   (or otherwise install ffmpeg)
  - pip install yt-dlp whisper-mps

Usage:
  python yt_to_text.py "https://www.youtube.com/watch?v=VIDEO_ID" --model base
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
from pathlib import Path


def run(cmd: list[str]) -> None:
    """Run a command, raising a nice error on failure."""
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        raise SystemExit(f"Command failed ({e.returncode}): {' '.join(cmd)}") from e


def safe_stem(name: str) -> str:
    name = re.sub(r"[^\w\-\. ]+", "", name).strip()
    name = re.sub(r"\s+", " ", name)
    return name or "output"


def download_mp4(url: str, out_dir: Path) -> Path:
    """
    Download best MP4 (or best available) and save as .mp4.
    We ask yt-dlp to merge to mp4 if needed.
    """
    if shutil.which("yt-dlp") is None:
        raise SystemExit("yt-dlp not found. Install with: pip install yt-dlp")

    out_dir.mkdir(parents=True, exist_ok=True)
    out_tpl = str(out_dir / "%(title).200B [%(id)s].%(ext)s")

    # Try to get an MP4 container when possible. If some videos can't be MP4,
    # yt-dlp may still produce mkv/webm; we handle that by converting whatever we get.
    cmd = [
        "yt-dlp",
        "-f",
        "bv*+ba/b",
        "--merge-output-format",
        "mp4",
        "-o",
        out_tpl,
        url,
    ]
    run(cmd)

    # Find newest downloaded media file in out_dir
    candidates = sorted(
        out_dir.glob("*.*"), key=lambda p: p.stat().st_mtime, reverse=True
    )
    if not candidates:
        raise SystemExit("No file downloaded by yt-dlp.")
    return candidates[0]


def to_mp3(input_media: Path, mp3_path: Path) -> Path:
    """Convert any input media to mp3."""
    if shutil.which("ffmpeg") is None:
        raise SystemExit("ffmpeg not found. Install first (e.g. brew install ffmpeg).")

    mp3_path.parent.mkdir(parents=True, exist_ok=True)
    cmd = [
        "ffmpeg",
        "-y",
        "-i",
        str(input_media),
        "-vn",
        "-acodec",
        "libmp3lame",
        "-b:a",
        "192k",
        str(mp3_path),
    ]
    run(cmd)
    return mp3_path


def transcribe_with_whisper_mps(audio_path: Path, model: str, json_out: Path) -> Path:
    """
    Uses whisper-mps CLI to transcribe to JSON.
    """
    if shutil.which("whisper-mps") is None:
        raise SystemExit("whisper-mps not found. Install with: pip install whisper-mps")

    json_out.parent.mkdir(parents=True, exist_ok=True)
    cmd = [
        "whisper-mps",
        "--file-name",
        str(audio_path),
        "--model-name",
        model,
        "--output-file-name",
        str(json_out),
    ]
    run(cmd)
    return json_out


def json_to_text(json_path: Path, txt_path: Path) -> Path:
    """
    Convert whisper-mps JSON output to plain text.
    Tries common keys: "text" or segments[*].text.
    """
    data = json.loads(json_path.read_text(encoding="utf-8"))

    text = ""
    if isinstance(data, dict):
        if isinstance(data.get("text"), str):
            text = data["text"]
        elif isinstance(data.get("segments"), list):
            parts = []
            for seg in data["segments"]:
                if isinstance(seg, dict) and isinstance(seg.get("text"), str):
                    parts.append(seg["text"].strip())
            text = "\n".join([p for p in parts if p])
    if not text:
        text = json.dumps(data, ensure_ascii=False, indent=2)

    txt_path.write_text(text.strip() + "\n", encoding="utf-8")
    return txt_path


def main():
    p = argparse.ArgumentParser(
        description="YouTube -> MP4 -> MP3 -> Whisper-MPS transcription"
    )
    p.add_argument("url", help="YouTube URL")
    p.add_argument(
        "--model",
        default="base",
        help="Whisper model: tiny/base/small/medium/large (default: tiny)",
    )
    p.add_argument(
        "--out-dir", default="outputs", help="Output directory (default: outputs)"
    )
    args = p.parse_args()

    out_dir = Path(args.out_dir)
    media_dir = out_dir / "media"
    text_dir = out_dir / "text"

    downloaded = download_mp4(args.url, media_dir)

    stem = safe_stem(downloaded.stem)
    mp3_path = media_dir / f"{stem}.mp3"
    json_path = text_dir / f"{stem}.json"
    txt_path = text_dir / f"{stem}.txt"

    mp3 = to_mp3(downloaded, mp3_path)
    json_out = transcribe_with_whisper_mps(mp3, args.model, json_path)
    txt_out = json_to_text(json_out, txt_path)

    print(f"Downloaded:   {downloaded}")
    print(f"Audio (mp3):  {mp3}")
    print(f"Transcript:   {json_out}")
    print(f"Text:         {txt_out}")


if __name__ == "__main__":
    main()
