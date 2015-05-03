# config.ru

root_dir = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift root_dir
$LOAD_PATH.unshift File.join(root_dir, 'lib')

require 'config/boot'
require 'wakawaka/api'
run Wakawaka::API

$LOAD_PATH.shift
