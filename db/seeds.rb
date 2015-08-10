# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create({ id: 1, username: 'admin', password: 'e10adc3949ba59abbe56e057f20f883e', name: 'votanhu' })
Photo.create([{ id: 1, id_user: 1, name: 'sample', url: 'sample.jpg' },
							{ id: 2, id_user: 1, name: 'sample', url: 'sample.jpg' },
							{ id: 3, id_user: 2, name: 'sample', url: 'sample.jpg' }])
Follow.create([{ id: 1, id_user: 1, id_follower: 2 },
							 { id: 2, id_user: 1, id_follower: 3 },
							 { id: 3, id_user: 3, id_follower: 1 }])