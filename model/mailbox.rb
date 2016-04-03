class Mailbox
	attr_accessor :id, :name, :slug, :email, :createdAt, :modifiedAt, :folders

	def initialize(id, name, slug, email, createdAt, modifiedAt, folders=[])
		@id = id
		@name = name
		@slut = slug
		@email = email
		@createdAt = createdAt
		@modifiedAt = modifiedAt
		@folders = folders
	end
end