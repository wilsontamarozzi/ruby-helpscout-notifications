class User
	attr_accessor :id, :firstName, :lastName, :email, :role, :timezone, :photoUrl, :createdAt, :modifiedAt

	def inicialize(id, firstName, lastName, email, role, timezone, photoUrl, createdAt, modifiedAt)
		@id = id
		@firstName = firstName
		@lastName = lastName
		@email = email
		@role = role
		@timezone = timezone
		@photoUrl = photoUrl
		@createdAt = createdAt
		@modifiedAt = modifiedAt
	end
end