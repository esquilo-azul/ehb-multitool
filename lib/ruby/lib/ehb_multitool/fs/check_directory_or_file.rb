# frozen_string_literal: true

module EhbMultitool
  module Fs
    # Deve ser implementado:
    # * check_file(path)
    # * recursive?
    module CheckDirectoryOrFile
      def check_path(path, level = 0)
        if File.file?(path)
          check_file(path)
        elsif File.directory?(path)
          inner_check_directory(path, level)
        end
      end

      def recursive?
        true
      end

      # @param level [Integer]
      # @return [Boolean]
      def process_path?(level)
        level.zero? || recursive?
      end

      def inner_check_directory(dir, level)
        return unless process_path?(level)

        check_directory(dir)
        Dir.entries(dir).sort.each do |e|
          next if e.start_with?('.')

          check_path(File.join(dir, e), level + 1)
        end
      end

      def check_file(file)
        # To override
      end

      def check_directory(dir)
        # To override
      end
    end
  end
end
