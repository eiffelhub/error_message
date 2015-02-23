note
	component:   "Eiffel Application Framework"
	description: "In-memory error database."
	keywords:    "error status reporting"
	author:      "Thomas Beale <thomas.beale@oceaninformatics.com>"
	support:     "http://www.openehr.org/issues/browse/AWB"
	copyright:   "Copyright (c) 2005- Ocean Informatics Pty Ltd <http://www.oceaninfomatics.com>"
	license:     "Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>"

class MESSAGE_DB

create
	make

feature -- Definitions

	Catchall_error: STRING = "(Error DB load failure); original error params $1; $2; $3; $4"

feature -- Initialisation

	make
		do
			create message_table.make (100)
		end

feature -- Access

	message_table: HASH_TABLE [STRING, STRING]
			-- error templates in the form of a table of templates keyed by id

	has_message (an_id: STRING): BOOLEAN
			-- True if message for `an_id' exists in `message_table'
		do
			Result := message_table.has (an_id)
		end

	create_message_content (an_id: STRING; args: detachable ARRAY[STRING]): STRING
			-- extract message for `an_id' from `message_table', perform substitutions from `args'
			-- and return the Result. If not found, return a standard message code error message.
		local
			i: INTEGER
			idx_str: STRING
			args_list: detachable ARRAY[STRING]
			replacement: STRING
		do
			-- obtain an error message for the code `an_id'
			if message_table.has (an_id) then
				check attached message_table.item (an_id) as msg then
					Result := msg.twin
				end
				args_list := args

			-- failing that, try to get an error message whose key is "message_code_error", which should
			-- be a message that looks like "Error code $1 does not exist (calling context = $2.$3)"
			-- (in whatever the generated language is)
			elseif message_table.has ("message_code_error") then
				check attached message_table.item ("message_code_error") as msg then
					Result := msg.twin
				end
				args_list := <<an_id>>

			-- Else use a hard-wired catchall error message
			else
				Result := Catchall_error.twin
			end

			-- replace literal %N character pairs with the real character '%N'
			Result.replace_substring_all ("%%N", "%N")

			-- do any argument replacements
			if attached args_list then
				from i := args_list.lower until i > args_list.upper loop
					replacement := args_list.item(i)
					if not attached replacement then
						create replacement.make_empty
					end
					idx_str := i.out
					idx_str.left_adjust
					Result.replace_substring_all ("$" + idx_str, replacement)
					i := i + 1
				end
			end
		end

	create_message_text (an_id: STRING): STRING
			-- extract fixed message for `an_id' from `message_table'
		do
			if message_table.has (an_id) then
				check attached message_table.item (an_id) as msg then
					Result := msg
				end
			elseif message_table.has ("message_code_error") then
				check attached message_table.item ("message_code_error") as msg then
					Result := msg.twin
				end
				Result.replace_substring_all ("$1", an_id)
			else -- catchall
				Result := Catchall_error.twin
			end
		end

	create_message_line (an_id: STRING; args: detachable ARRAY[STRING]): STRING
			-- same as `create_message_content' but with added newline at end
		do
			Result := create_message_content (an_id, args)
			Result.append_character ('%N')
		end

feature -- Status Report

	database_loaded: BOOLEAN
		do
			Result := not message_table.is_empty
		end

feature -- Modification

	add_table (a_msg_table: MESSAGE_DB)
		do
			message_table.merge (a_msg_table.message_table)
		end

end
