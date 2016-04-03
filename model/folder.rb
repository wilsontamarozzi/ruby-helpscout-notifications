class Folder
	attr_accessor :id, :name, :type, :userId, :totalCount, :activeCount, :modifiedAt

	def initialize(id, name, type, userId, totalCount, activeCount, modifiedAt)
		@id = id
		@name = name
		@slut = type
		@userId = userId
		@totalCount = totalCount
		@activeCount = activeCount
		@modifiedAt = modifiedAt
	end
end