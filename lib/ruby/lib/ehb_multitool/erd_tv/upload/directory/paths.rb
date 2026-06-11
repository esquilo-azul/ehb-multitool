# frozen_string_literal: true

module EhbMultitool
  module ErdTv
    module Upload
      class Directory
        module Paths
          DEFAULT_TARGET_MKDIR = false

          private

          def build_path(prefix)
            ::File.join(send("#{prefix}_root_path"), build_subpath(prefix))
          end

          def build_subpath(prefix)
            return options.fetch(prefix) if options.key?(prefix)

            ::File.join(options.fetch(:"#{prefix}_parent"),
                        options[:"#{prefix}_basename"] || id.to_s)
          end

          def from
            build_path(OPTION_SOURCE)
          end

          def source_root_path
            disk_instance_uncached.read_entry('source_root')
          end

          # @return [Boolean]
          def target_mkdir?
            return options.fetch(OPTION_TARGET_MKDIR) if options.key?(OPTION_TARGET_MKDIR)

            DEFAULT_TARGET_MKDIR
          end

          def target_root_path
            if bbfln90?
              bbfln90_root_path
            else
              disk_instance_uncached.read_entry('target_root')
            end
          end

          def to
            build_path(OPTION_TARGET)
          end
        end
      end
    end
  end
end
