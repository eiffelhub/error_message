note
	component:   "Eiffel Object Modelling Framework"
	description: "Abstract model of a validator object that reports errors, warnings."
	keywords:    "Validation, parsing"
	author:      "Thomas Beale <thomas.beale@openehr.org>"
	support:     "http://www.openehr.org/issues/browse/AWB"
	copyright:   "Copyright (c) 2007- The openEHR Foundation <http://www.openEHR.org>"
	license:     "Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>"

deferred class ANY_VALIDATOR

inherit
	SHARED_MESSAGE_DB
		export
			{NONE} all;
			{ANY} deep_copy, deep_twin, is_deep_equal, standard_is_equal
		end

feature -- Initialisation

	reset
			-- initialise reporting variables
		do
			passed := True
			create error_cache.make
		ensure
			Passed: passed
			Errors_cleared: errors.is_empty
		end

feature -- Access

	errors: ERROR_ACCUMULATOR
			-- error output of validator - things that must be corrected
		do
			if attached error_cache as att_errors then
				Result := att_errors
			else
				create Result.make
				error_cache := Result
			end
		end

	error_strings: STRING
		do
			Result := errors.as_string
		end

feature -- Status Report

	has_errors: BOOLEAN
		do
			Result := errors.has_errors
		end

	has_error (a_code: READABLE_STRING_8): BOOLEAN
		do
			Result := errors.has_error (a_code)
		end

	has_warnings: BOOLEAN
		do
			Result := errors.has_warnings
		end

feature -- Modification

	merge_errors (other_errors: ERROR_ACCUMULATOR)
		do
			errors.append (other_errors)
			passed := passed and not other_errors.has_errors
		end

	merge_errors_from_other (other_errors: ERROR_ACCUMULATOR; other_id: STRING)
		do
			errors.append_from_other (other_errors, other_id)
			passed := passed and not other_errors.has_errors
		end

	add_error (a_key: READABLE_STRING_8; args: detachable ARRAY [READABLE_STRING_8])
			-- append an error with key `a_key' and `args' array to the `errors' string
		do
			add_error_with_location (a_key, args, "")
		end

	add_warning (a_key: READABLE_STRING_8; args: detachable ARRAY [READABLE_STRING_8])
			-- append a warning with key `a_key' and `args' array to the `warnings' string
		do
			add_warning_with_location (a_key, args, "")
		end

	add_info (a_key: READABLE_STRING_8; args: detachable ARRAY [READABLE_STRING_8])
			-- append an information message with key `a_key' and `args' array to the `information' string
		do
			add_info_with_location (a_key, args, "")
		end

	add_error_with_location (a_key: READABLE_STRING_8; args: detachable ARRAY [READABLE_STRING_8]; a_location: READABLE_STRING_8)
			-- append an error with key `a_key' and `args' array to the `errors' string
		do
			errors.extend (create {ERROR_DESCRIPTOR}.make_error (a_key, get_msg (a_key, args), a_location))
			passed := False
		end

	add_warning_with_location (a_key: READABLE_STRING_8; args: detachable ARRAY [READABLE_STRING_8]; a_location: READABLE_STRING_8)
			-- append a warning with key `a_key' and `args' array to the `warnings' string
		do
			errors.extend (create {ERROR_DESCRIPTOR}.make_warning (a_key, get_msg (a_key, args), a_location))
		end

	add_info_with_location(a_key: READABLE_STRING_8; args: detachable ARRAY [READABLE_STRING_8]; a_location: READABLE_STRING_8)
			-- append an information message with key `a_key' and `args' array to the `information' string
		do
			errors.extend (create {ERROR_DESCRIPTOR}.make_info (a_key, get_msg (a_key, args), a_location))
		end

feature -- Status Report

	passed: BOOLEAN
			-- True if validation succeeded

	ready_to_validate: BOOLEAN
		do
			Result := passed
		end

feature -- Validation

	validate
		require
			ready_to_validate
		deferred
		end

feature {NONE} -- Access

	error_cache: detachable ERROR_ACCUMULATOR
			-- error output of validator - things that must be corrected
		note
			option: transient
		attribute
		end

end


