note
	component:   "Eiffel Application Framework"
	description: "Test application for error_message library"
	keywords:    "errors, messages"
	author:      "Thomas Beale <thomas.beale@oceaninformatics.com>"
	support:     "http://www.openehr.org/issues/browse/AWB"
	copyright:   "Copyright (c) 2015- Ocean Informatics Pty Ltd <http://www.oceaninfomatics.com>"
	license:     "Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>"

class APP_DEFINITIONS

inherit
	ERROR_SEVERITY_TYPES

	SHARED_MESSAGE_DB
		export
			{NONE} all
		end

	GLOBAL_ERROR_REPORTING_LEVEL
		export
			{NONE} all
		end

	TEST_COMPILED_MESSAGE_IDS
		export
			{NONE} all
		end

end


