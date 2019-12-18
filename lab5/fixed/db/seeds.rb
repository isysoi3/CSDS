# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tim = User.create(email: "tim@testing.com", password: "testing", admin: true)
admin = User.create(email: "admin@testing.com", password: "ca829SF", admin: true)
matty = User.create(email: "matty@testing.com", password: "testing")
eric = User.create(email: "eric@testing.com", password: "testing")
lisa = User.create(email: "lisa@testing.com", password: "testing")
eduardo = User.create(email: "eduardo@testing.com", password: "testing")


matty.posts.create(title: "Wordpress", content: "WordPress.com is the easiest way to create a free website or blog. It’s a powerful hosting platform that grows with you.", public: true)
matty.posts.create(title: "Ghost", content: "Ghost is a platform dedicated to one thing: Publishing. It's beautifully designed, completely customisable and completely Open Source. Ghost allows you to write and publish your own blog, giving you the tools to make it easy and even fun to do.", public: true)
matty.posts.create(title: "Confessions", content: "Somtimes I drink milk straight from the carton", public: false)

eric.posts.create(title: "Go Mets", content: "The New York Mets are an American professional baseball team based in New York City. The Mets are a member of the National League East Division of Major League Baseball.", public: true)
eric.posts.create(title: "Go Yankees", content: "Most of the time I'm a yankees fan", public: false)

lisa.posts.create(title: "Hello Kitty", content: "Sanrio is the official home of Hello Kitty & Friends.", public: true)
lisa.posts.create(title: "AC/DC", content: "I love AC/DC", public: false)

eduardo.posts.create(title: "Kittens", content: "As a software engineer, I must like kittens", public: true)
eduardo.posts.create(title: "Puppies", content: "I also love puppies", public: true)
eduardo.posts.create(title: "Security", content: "XSS enables attackers to inject client-side script into web pages viewed by other users.", public: true)
