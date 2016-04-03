class Conversation
	attr_accessor :id, :type, :folderId, :isDraft, :number, :owner, :mailbox, :customer, 
		:threadCount, :status, :subject,:preview, :createdBy, :createdAt, :userModifiedAt, 
		:closedAt, :closedBy, :source, :cc, :bcc, :tags

	def initialize(id, type, folderId, isDraft, number, owner, mailbox, customer, 
		threadCount, status, subject,preview, createdBy, createdAt, userModifiedAt, 
		closedAt, closedBy, source, cc, bcc, tags)

		@id = id
		@type = type
		@folderId = folderId
		@isDraft = isDraft
		@number = number
		@owner = owner
		@mailbox = mailbox
		@customer = customer
		@threadCount = threadCount
		@status = status
		@subject = subject
		@preview = preview
		@createdBy = createdBy
		@createdAt = createdAt
		@userModifiedAt = userModifiedAt
		@closedAt = closedAt
		@closedBy = closedBy
		@source = source
		@cc = cc
		@bcc = bcc
		@tags = tags		
	end
end