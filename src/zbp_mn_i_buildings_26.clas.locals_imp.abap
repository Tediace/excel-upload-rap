class lhc_Building definition inheriting from cl_abap_behavior_handler.
  private section.

    methods get_instance_authorizations for instance authorization
      importing keys request requested_authorizations for Building result result.

    methods validateNRooms for validate on save
      importing keys for Building~validateNRooms.

endclass.

class lhc_Building implementation.

  method get_instance_authorizations.
  endmethod.

  method validateNRooms.
    " reading the building entites
    READ ENTITIES OF zmn_i_buildings_26 IN LOCAL MODE
         ENTITY Building
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(buildings)
         FAILED DATA(building_failed).

    IF building_failed IS NOT INITIAL.
      " if the above read fails then return the error message
      failed = CORRESPONDING #( DEEP building_failed ).
      RETURN.
    ENDIF.

    LOOP AT buildings ASSIGNING FIELD-SYMBOL(<building>).

      IF NOT <building>-NRooms BETWEEN 1 AND 10.

        " if bulk upload, then the excel row no field will not be initial,
        " creating a message prefix for the output message
        DATA(lv_msg) = |No of Rooms must be in Range 1 to 10|.
        lv_msg = COND #( WHEN <building>-ExcelRowNumber IS INITIAL
                         THEN lv_msg
                         ELSE |Row { <building>-ExcelRowNumber }: { lv_msg }| ).

        APPEND VALUE #( %tky = <building>-%tky )
               TO failed-building.

        APPEND VALUE #( %tky            = <building>-%tky
                        %state_area     = 'Validate_Rooms'
                        %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = lv_msg )
                        %element-NRooms = if_abap_behv=>mk-on )
               TO reported-building.
      ENDIF.

      CLEAR lv_msg.

    ENDLOOP.
  endmethod.

endclass.

class lsc_ZMN_I_BUILDINGS_26 definition inheriting from cl_abap_behavior_saver.
  protected section.

    methods adjust_numbers redefinition.

    methods cleanup_finalize redefinition.

endclass.

class lsc_ZMN_I_BUILDINGS_26 implementation.

  method adjust_numbers.
  endmethod.

  method cleanup_finalize.
  endmethod.

endclass.
