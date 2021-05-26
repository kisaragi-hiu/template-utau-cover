UTAU = env WINEPREFIX=/home/kisaragi-hiu/.wineprefix/UTAU wine "C:\\Program Files (x86)\\UTAU\\utau.exe"
# UTAU = env WINEPREFIX=/home/kisaragi/.wineprefix/UTAU wine "C:\\Program Files\\UTAU\\utau.exe"

# UST in ust/; rendered .wav files in project root
# You need to specify project root when rendering in UTAU
WAV = $(patsubst %.ust,%.wav,$(notdir $(shell find -name "*.ust")))

# * Vocal
vocal: $(WAV)
.PHONY: vocal

$(WAV): %.wav: ust/%.ust
	$(UTAU) "$(realpath $<)"

# * Audio
audio: export.ogg export.wav
.PHONY: audio

export.ogg: export.wav
	ffmpeg -y -i export.wav export.ogg

# Rename the file
export.wav: Mix/Mix.ardour $(WAV)
	ardour6-export Mix Mix --output export.wav

# * Video
video: export.mkv
.PHONY: video

export.mkv: Original.mp4 export.wav
	ffmpeg -y \
	    -i Original.mp4 -i export.wav \
	    -map "0:v" -map "1:a" \
	    -c:v copy
	    "$@"

# * Utilities
clean-except-final:
	rm -r $(WAV) *.cache *.bak
.PHONY: clean-except-final
