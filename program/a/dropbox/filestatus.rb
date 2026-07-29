#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class FsStatus
  include ::EacRubyUtils::SimpleCache

  class << self
    def build_from_line(parent, line)
      name, status = parse_line(line)
      name && status ? new(parent, name, status) : nil
    end

    private

    def parse_line(line)
      m = /\A(.+):([^:]+)\z/.match(line)
      return [m[1].strip, m[2].strip] if m

      [nil, nil]
    end
  end

  attr_reader :parent, :name, :status

  def initialize(parent, name, status)
    @parent = parent
    @name = name
    @status = status
  end

  def output_children(level)
    children.each do |c|
      c.output(level)
    end
  end

  def output(level)
    return unless status == 'syncing'

    puts(('  ' * level) << name)
    output_children(level + 1)
  end

  def children
    return [] unless directory?

    r = []
    s.each_line do |l|
      x = self.class.build_from_line(self, l)
      r << x if x
    end
    r
  end

  def path_uncached
    s = name
    s = "#{parent.path}/#{s}" if parent
    s
  end

  def directory?
    File.directory?(path)
  end

  def s
    Dir.chdir path do
      ::EacRubyUtils::Envs.local.command('dropbox', 'filestatus').execute!
    end
  end
end

class Runner
  def initialize(root)
    FsStatus.new(nil, root, '').output_children(0)
  end
end

if ARGV.empty?
  Runner.new('.')
else
  ARGV.each { |a| Runner.new(a) }
end
