require 'yaml'
require 'test/unit'
CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'environment.yaml'))
ACCOUNTS = YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'accounts.yaml'))

require File.expand_path(File.dirname(__FILE__) + "/../lib/aq_ruby")
