#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class ClearDevelopmentProjects
  enable_speaker
  enable_simple_cache

  attr_reader :root

  def initialize(root)
    @root = root
  end

  def run
    infov 'Searching in', root
    exclude = []
    Dir.glob("#{root}/**/*/").each do |d|
      project_patterns(d).each do |p|
        infov '  * Project found', "#{d} (#{p.class.name})"
        exclude += to_exclude(p, d)
      end
    end
    dropbox_exclude(exclude)
  end

  def project_patterns(directory)
    r = []
    patterns.each do |p|
      r << p.new(directory) if p.project?(directory)
    end
    r
  end

  def to_exclude(pattern, directory)
    pattern.subdirs.map { |s| "#{directory}#{s}" }.select { |s| File.exist?(s) }
  end

  def dropbox_exclude(_exclude)
    raise 'TO-DO: fix with https://help.dropbox.com/pt-br/files-folders/restore-delete/ignored-files'
    # raise 'TO-DO: causa "selective sync conflict"'
    # cmd = %w[dropbox exclude add] + exclude
    # puts cmd.to_s
    # system(*cmd)
  end

  def patterns
    [MavenProject, RailsProject, SnapProject]
  end
end

class MavenProject
  def initialize(directory)
    @directory = directory
  end

  def subdirs
    %w[target]
  end

  def self.project?(directory)
    File.exist?(File.expand_path('pom.xml', directory))
  end
end

class RailsProject
  def initialize(directory)
    @directory = directory
  end

  def subdirs
    %w[tmp log files public/uploads]
  end

  def self.project?(directory)
    File.exist?(File.expand_path('config.ru', directory))
  end
end

class SnapProject
  def initialize(directory)
    @directory = directory
  end

  def subdirs
    %w[parts prime stage]
  end

  def self.project?(directory)
    %w[snapcraft.yaml snapcraft.yml].any? do |basename|
      File.exist?(File.expand_path("snap/#{basename}", directory))
    end
  end
end

class ExcludeDevTempRunner
  runner_with :help do
    desc 'Exclui do Dropbox arquivos voláteis em projetos de software.'
    pos_arg :paths, repeat: true, optional: true
  end

  def run
    parsed.paths.each do |root|
      ::ClearDevelopmentProjects.new(root).run
    end
  end
end

ExcludeDevTempRunner.run
