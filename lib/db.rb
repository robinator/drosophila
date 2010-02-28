require 'rubygems'
require 'sequel'

DB = Sequel.connect('mysql://root@localhost/ammigration')

leads = DB[:leads]

leads.each do |l|
  puts l.id
end