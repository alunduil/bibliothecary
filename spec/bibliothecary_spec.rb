require 'spec_helper'

describe Bibliothecary do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  it 'lists supported package managers' do
    expect(described_class.package_managers).to eq([
          Bibliothecary::Parsers::Bower,
          Bibliothecary::Parsers::Cargo,
          Bibliothecary::Parsers::Carthage,
          Bibliothecary::Parsers::Clojars,
          Bibliothecary::Parsers::CocoaPods,
          Bibliothecary::Parsers::CPAN,
          Bibliothecary::Parsers::CRAN,
          Bibliothecary::Parsers::Dub,
          Bibliothecary::Parsers::Elm,
          Bibliothecary::Parsers::Go,
          Bibliothecary::Parsers::Haxelib,
          Bibliothecary::Parsers::Hex,
          Bibliothecary::Parsers::Julia,
          Bibliothecary::Parsers::Maven,
          Bibliothecary::Parsers::Meteor,
          Bibliothecary::Parsers::NPM,
          Bibliothecary::Parsers::Nuget,
          Bibliothecary::Parsers::Packagist,
          Bibliothecary::Parsers::Pub,
          Bibliothecary::Parsers::Pypi,
          Bibliothecary::Parsers::Rubygems,
          Bibliothecary::Parsers::Shard,
          Bibliothecary::Parsers::SwiftPM
        ])
  end

  it 'identifys manifests from a list of file paths' do
    expect(described_class.identify_manifests(['package.json', 'README.md', 'index.js'])).to eq([
      'package.json'
      ])
  end

  it 'identifys manifests from a list of file paths except ignored ones' do
    expect(described_class.identify_manifests(['package.json', 'bower_components/package.json', 'README.md', 'index.js'])).to eq([
      'package.json'
      ])
  end

  it 'analyses contents of a file' do
    expect(described_class.analyse_file('bower.json', load_fixture('bower.json'))).to eq([{
      :platform=>"bower",
      :path=>"bower.json",
      :dependencies=>[
        {:name=>"jquery", :requirement=>">= 1.9.1", :type=>"runtime"}
      ],
      :kind => 'manifest'
    }])
  end

  it 'ignores certain files' do
    expect(described_class.ignored_files_regex).to eq(".git|node_modules|bower_components|spec/fixtures|vendor|dist")
  end

  it 'searches a folder for manifests and parses them' do
    analysis = described_class.analyse('./')
    # empty out any dependencies to make the test more reliable.
    # we test specific manifest parsers in the parsers specs
    analysis.each do |a|
      a[:dependencies] = []
    end
    expect(analysis).to eq(
      [{:platform=>"rubygems",
        :path=>"Gemfile",
        :dependencies=>[],
         :kind => 'manifest'},
       {:platform=>"rubygems",
        :path=>"Gemfile.lock",
        :dependencies=>[],
        :kind => 'lockfile'},
       {:platform=>"rubygems",
        :path=>"bibliothecary.gemspec",
        :dependencies=>[],
        :kind => 'manifest'}])
  end
end
