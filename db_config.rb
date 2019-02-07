options = {
    adapter: 'postgresql',
    database: 'faction_db'
  }
  
  ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)