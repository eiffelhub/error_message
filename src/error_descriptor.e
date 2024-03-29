note
	component:   "Eiffel Application Framework"
	description: "Error descriptor abstraction"
	keywords:    "error status reporting"

	author:      "Thomas Beale <thomas.beale@oceaninformatics.com>"
	support:     "http://www.openehr.org/issues/browse/AWB"
	copyright:   "Copyright (c) 2010- Ocean Informatics Pty Ltd <http://www.oceaninfomatics.com>"
	license:     "Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>"

class ERROR_DESCRIPTOR

inherit
	ERROR_SEVERITY_TYPES

create
	make, make_error, make_warning, make_info, make_debug

feature -- Initialisation

	make_error (a_code, a_message: READABLE_STRING_8; a_loc: detachable READABLE_STRING_8)
		do
			make (a_code, error_type_error, a_message, a_loc)
		end

	make_warning (a_code, a_message: READABLE_STRING_8; a_loc: detachable READABLE_STRING_8)
		do
			make (a_code, error_type_warning, a_message, a_loc)
		end

	make_info (a_code, a_message: READABLE_STRING_8; a_loc: detachable READABLE_STRING_8)
		do
			make (a_code, error_type_info, a_message, a_loc)
		end

	make_debug (a_message: READABLE_STRING_8; a_loc: detachable READABLE_STRING_8)
		do
			make ("", error_type_debug, a_message, a_loc)
		end

	make (a_code: READABLE_STRING_8; a_severity: INTEGER; a_message: READABLE_STRING_8; a_loc: detachable READABLE_STRING_8)
		require
			Severity_valid: is_valid_error_type (a_severity)
		do
			artefact_id := ""
			code := a_code
			severity := a_severity
			message := a_message
			location := a_loc
		end

feature -- Access

	artefact_id: READABLE_STRING_8

	code: READABLE_STRING_8

	severity: INTEGER

	message: READABLE_STRING_8

	location: detachable READABLE_STRING_8

feature -- Modification

	set_artefact_id (a_str: STRING)
			-- set artefact_id to a_str
		do
			artefact_id := a_str
		end

feature -- Output

	as_string: STRING
		do
			if not artefact_id.is_empty then
				create Result.make_from_string ("[" + artefact_id + "]: ")
			else
				create Result.make_empty
			end
			Result.append (error_type_name (severity) + " ")
			if attached location as att_loc and then not att_loc.is_empty then
				Result.append (att_loc + ": ")
			end
			Result.append ("(" + code + ") " + message)
		end

invariant
	is_valid_error_type (severity)

end



