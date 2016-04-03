require "rubygems"
require "httparty"
require "json"

require_relative 'model/mailbox'
require_relative 'model/folder'
require_relative 'model/user'
require_relative 'model/conversation'

class HelpScout
	include HTTParty

	default_options.update(verify: false)

	base_uri 'https://api.helpscout.net/v1'

	def initialize(user, password)
		@auth = { :username => user, :password => password }
	end

	def getListMailboxes
		data = connectToWebservice('/mailboxes.json')

		mailboxes = []

		data['items'].each do | i |
			mailboxes.push(Mailbox.new(
				i['id'], 		i['name'], 
				i['slug'], 		i['email'], 
				i['createdAt'],	i['modifiedAt']
			))
		end

		return mailboxes
	end

	def getListFolders(mailboxId)
		data = connectToWebservice("/mailboxes/#{mailboxId}/folders.json")

		folders = []

		data['items'].each do | i |
			folders.push(Folder.new(
				i['id'], 			i['name'], 
				i['type'], 			i['userId'], 
				i['totalCount'], 	i['activeCount'], 
				i['modifiedAt']
			))
		end

		return folders
	end

	def getListUsers
		data = connectToWebservice('/users.json')

		users = []

		data['items'].each do | i |
			users.push(User.new(
				i['id'],		i['firstName'],
				i['lastName'],	i['email'],
				i['role'],		i['timezone'],
				i['photoUrl'],	i['createdAt'],
				i['modifiedAt']
			))
		end
	end

	def getListConversation(mailboxId)
		data = connectToWebservice("/mailboxes/#{mailboxId}/conversations.json")

		conversations = []

		data['items'].each do | i |
			conversations.push(Conversation.new(
				i['id'], 			i['type'],		i['folderId'], 		i['isDraft'],
				i['number'], 		i['owner'],		i['mailbox'],		i['customer'],
				i['threadCount'],	i['status'],	i['subject'],		i['preview'],
				i['createdBy'],		i['createdAt'],	i['modifiedAt'],	i['closedAt'],
				i['closedBy'],		i['source'],	i['cc'],			i['bcc'],
				i['tags']
			))
		end

		return conversations
	end

	def getListConversationByFolder(mailboxId, folderId, isDraft)
		data = connectToWebservice("/mailboxes/#{mailboxId}/folders/#{folderId}/conversations.json")

		conversations = []

		data['items'].each do | i |
			if i['isDraft'] == isDraft || isDraft == nil
				conversations.push(Conversation.new(
					i['id'], 			i['type'],		i['folderId'], 		i['isDraft'],
					i['number'], 		i['owner'],		i['mailbox'],		i['customer'],
					i['threadCount'],	i['status'],	i['subject'],		i['preview'],
					i['createdBy'],		i['createdAt'],	i['userModifiedAt'],i['closedAt'],
					i['closedBy'],		i['source'],	i['cc'],			i['bcc'],
					i['tags']
				))
			end
		end

		return conversations
	end

	def connectToWebservice(url, options={})
		options.merge!({:basic_auth => @auth})

		response = self.class.get(url, options)

		return data = JSON.parse(response.body)
	end

	def checkNewConversation(mailbox, options={})

		firstCheck = nil

		while true
			conversations = []

			mailbox.folders.each do | folder |
				data = getListConversationByFolder(mailbox.id, folder.id, false)

				data.sort! { |a, b| a.userModifiedAt <=> b.userModifiedAt}

				conversations.push({
					:count => data.length,
					:conversations => data,
					:folder => folder
				})
			end

			if firstCheck == nil
				firstCheck = conversations
			end

			i = 0
			while i < conversations.length do
				oldCount = firstCheck[i][:count]
			 	newCount = conversations[i][:count]
			 	folder = conversations[i][:folder]

			 	if newCount != oldCount 
			 		firstCheck = conversations

			 		if newCount > oldCount
			 			email = conversations[i][:conversations]

			 			puts "****************************************************"
			 			puts "Novo E-mail - #{folder.name}"						
			 			puts "#{email[email.length-1].number} - #{email[email.length-1].subject} \n- #{email[email.length-1].preview}"
			 			puts "****************************************************"
			 		else
			 			puts "#{folder.name} - E-mail respondido."
			 		end 
			 	else
			 		puts "#{folder.name} - Nenhum novo e-mail."
				end
			 	i += 1
			end

			sleep(6)
		end
	end

	def chooseMailBoxes

		choose = []
		mailboxes = getListMailboxes
		option = 1

		while option != 0

			puts "*******************************"
			puts "Escolher uma ou mais Mailbox"			
			puts "0: Próximo passo."

			count = 1
			mailboxes.each do | i |
				puts "#{count}: #{i.name} | #{i.email}"
				count += 1
			end

			option = gets.to_i
			
			if option != 0
				mailbox = mailboxes[option-1]
				choose.push(mailbox)
				mailboxes.delete_at(option-1)

				puts "-------------------------------"
				puts "#{mailbox.name} foi adicionado."
				puts "-------------------------------"
			end
		end

		return choose
	end

	def chooseFolders(mailboxes)

		mailboxes.each do | mailbox |
			choose = []
			folders = getListFolders(mailbox.id)
			option = 1

			while option != 0

				puts "*******************************"
				puts "Escolher uma ou mais Folder"			
				puts "0: Próximo passo."

				count = 1
				folders.each do | i |
					puts "#{count}: #{i.name}"
					count += 1
				end

				option = gets.to_i
				
				if option != 0
					folder = folders[option-1]
					choose.push(folder)
					folders.delete_at(option-1)

					puts "-------------------------------"
					puts "#{folder.name} foi adicionado."
					puts "-------------------------------"
				end
			end

			mailbox.folders = choose
		end

		return mailboxes
	end

	def start
		mailboxes = chooseMailBoxes

		mailboxes = chooseFolders(mailboxes)

		mailboxes.each do | mailbox |
			t = Thread.new{
				checkNewConversation(mailbox)
			}

			t.join
		end
	end
end

helpscout = HelpScout.new("API_KEY", "X")
helpscout.start