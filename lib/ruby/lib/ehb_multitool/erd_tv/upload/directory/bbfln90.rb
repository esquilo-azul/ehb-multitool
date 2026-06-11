# frozen_string_literal: true

module EhbMultitool
  module ErdTv
    module Upload
      class Directory
        module Bbfln90
          private

          def bbfln90?
            options.fetch(OPTION_BBFLN90)
          end

          def bbfln90_uncached
            ::Avm::Instances::Base.by_id 'bbfln_90'
          end

          def bbfln90_root_path
            "#{bbfln90.read_entry('install.url')}" \
              "#{bbfln90.read_entry("#{disk_instance.id}.fs.path")}"
          end
        end
      end
    end
  end
end
