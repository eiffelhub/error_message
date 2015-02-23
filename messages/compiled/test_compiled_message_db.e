note
	component:   "Eiffel Object Modelling Framework"
	description: "Generated class from message text files"
	keywords:    "Internationalisation, I18N, Localisation, L10N, command line"
	author:      "Thomas Beale <thomas.beale@oceaninformatics.com>"
	support:     "Ocean Informatics <support@OceanInformatics.com>"
	copyright:   "Copyright (c) 2012 Ocean Informatics Pty Ltd"
	license:     "Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>"

class TEST_COMPILED_MESSAGE_DB

inherit
	TEST_COMPILED_MESSAGE_IDS

	MESSAGE_DB
		redefine
			make
		end

create
	make

feature -- Initialisation

	make
		do
			create message_table.make (10)
			message_table.put ("Error code $1 does not exist (calling context = $2.$3)", ec_message_code_error)
			message_table.put ("Software Exception $1 caught; Stack:%N$2", ec_report_exception)
			message_table.put ("$1", ec_general_error)
			message_table.put ("Read failed; file $1 does not exist.", ec_read_failed_file_does_not_exist)
			message_table.put ("Application launched", ec_app_launched)
			message_table.put ("No config file found, expected in $1", ec_missing_config_file_warning)
			message_table.put ("App object 1 wrong path $1 on item $2", ec_app_obj_1_path_error)
			message_table.put ("App object 1 wrong file $1 on system $2", ec_app_obj_1_file_error)
			message_table.put ("App object 2 wrong path $1 on item $2", ec_app_obj_2_path_error)
			message_table.put ("App object 2 wrong file $1 on system $2", ec_app_obj_2_file_error)
end	
end