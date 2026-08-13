# frozen_string_literal: true

module EhbMultitool
  module Videos
    class FfmpegProfile
      attr_reader :extension, :name, :avconv_args

      class << self
        def ogv
          @ogv ||= new('ogv', %w[-acodec libvorbis -vcodec libvorbis -f ogv])
        end

        def mp3
          @mp3 ||= new('mp3', %w[-codec:a libmp3lame -f mp3])
        end

        def mp4
          @mp4 ||= new('mp4', %w[-acodec aac -vcodec libx264 -f mp4])
        end

        def mp4_copy
          @mp4_copy ||= new('mp4_copy', %w[-acodec copy -vcodec copy -f mp4])
        end

        def mp4_nosound
          @mp4_nosound ||= new('mp4_nosound', %w[-an -vcodec libx264 -f mp4])
        end

        def all
          @all ||= [ogv, mp3, mp4, mp4_copy, mp4_nosound]
        end

        def by_name(name)
          all.find { |p| p.name == name }
        end
      end

      def initialize(name, avconv_args)
        @name = name
        @avconv_args = avconv_args
      end

      def ffmpeg_args
        super + avconv_args
      end
    end
  end
end
