require 'rails_helper'

RSpec.describe CloudFile, type: :model do
  describe ".type_for" do
    it "detects Movie filenames correctly" do
      expect(described_class.type_for("Diary of a Wimpy Kid Dog Days _2012_.zip")).to eq(:movie)
      expect(described_class.type_for("Diary Of A Wimpy Kid [Duology].zip")).to eq(:movie)
      expect(described_class.type_for("Diary of a Wimpy Kid trilogy _2010_ 2011_2012_ 720p DTS multisub HighCode")).to eq(:movie)
      expect(described_class.type_for("Dune.2021.1080p.HDRip.X264-EVO[TGx].zip")).to eq(:movie)
      expect(described_class.type_for("The.Circle.2017.HDRip.XviD.AC3-EVO.zip")).to eq(:movie)
    end

    it "detects TV filenames correctly" do
      expect(described_class.type_for("Foundation.S01E07.1080p.WEB.H264-CAKES[eztv.re].mkv")).to eq(:tv)
      expect(described_class.type_for("Foundation.S01E06.1080p.HEVC.x265-MeGusta[eztv.re].mkv")).to eq(:tv)
      expect(described_class.type_for("The Mandalorian Season 2 Mp4 1080p.zip")).to eq(:tv)
      expect(described_class.type_for("The Mandalorian Season 1 Mp4 1080p.zip")).to eq(:tv)
      expect(described_class.type_for("foundation.s01e05.1080p.web.h264-cakes[eztv.re].mkv")).to eq(:tv)
      expect(described_class.type_for("foundation.s01e04.1080p.web.h264-cakes[eztv.re].mkv")).to eq(:tv)
      expect(described_class.type_for("Foundation.S01E03.1080p.HEVC.x265-MeGusta[eztv.re].mkv")).to eq(:tv)
      expect(described_class.type_for("Foundation.S01E02.1080p.HEVC.x265-MeGusta[eztv.re].mkv")).to eq(:tv)
      expect(described_class.type_for("foundation.s01e02.720p.web.h264-ggez[eztv.re].mkv")).to eq(:tv)
      expect(described_class.type_for("foundation.s01e01.720p.web.h264-ggez[eztv.re].mkv")).to eq(:tv)
      expect(described_class.type_for("Mythic.Quest.Ravens.Banquet.S02.COMPLETE.720p.ATVP.WEBRip.x264-GalaxyTV[TGx].zip")).to eq(:tv)
    end
  end
end
