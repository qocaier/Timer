[include now.cfg]

[save_variables]
filename: /usr/data/printer_data/config/Timer-Script/vars.cfg

[gcode_shell_command _write_curr_time]
command: sh -c "date $'+[gcode_macro _now]\nvariable_hr: %-H\nvariable_min: %-M\ngcode:' > /usr/data/printer_data/config/Timer-Script/now.cfg"
timeout: 1
verbose: False

[gcode_macro TIMER]
variable_hours_need: 0
variable_minutes_need: 0
variable_flag: 0
gcode:
    {% set hours = params.HOURS|default(0) | int %}
	{% set minutes = params.MINUTES|default(0) | int %}
	{% set is_duration = params.IS_DURATION|default(0) | int %}

    {% if hours < 0 or hours > 23 or minutes < 0 or minutes > 59 or (is_duration != 0 and is_duration != 1) %}
		RESPOND TYPE=error MSG="Abnormal input! Change parameters and run this macro again"
	{% else %}
		{% if hours == 0 and minutes == 0 %}
			{% set hours = 1 %}
		{% endif %}
		{% if is_duration == 0 %}
			RESPOND TYPE=command MSG="Firmware will reboot right now. Don't worry, timer will set after that"
			RUN_SHELL_COMMAND cmd=_write_curr_time
			SAVE_VARIABLE VARIABLE=hours_need VALUE={hours}
			SAVE_VARIABLE VARIABLE=minutes_need VALUE={minutes}
			SAVE_VARIABLE VARIABLE=flag VALUE=1
			SAVE_CONFIG
		{% else %}
			RESPOND TYPE=command MSG="Printing will continue AFTER {hours} hours and {minutes} minutes"
			{% set wait = hours * 60 + minutes %}
			_timer_wait WAIT={wait}
		{% endif %}
	{% endif %}

[delayed_gcode _count_time]
initial_duration: 1
gcode:
	{% set vars = printer.save_variables.variables %}
	{% if vars.flag == 1 %}
		RESPOND TYPE=command MSG="Printing will continue AT {vars.hours_need}:{vars.minutes_need}"
		SAVE_VARIABLE VARIABLE=flag VALUE=0
		{% set wait = ((24 + vars.hours_need - printer["gcode_macro _now"].hr) * 60 + (vars.minutes_need - printer["gcode_macro _now"].min)) % (24 * 60) %}
		_timer_wait WAIT={wait}
	{% endif %}

[gcode_macro _timer_wait]
gcode:
	{% set wait = params.WAIT|default(60) | int %}
		
    {% for i in range(wait) %}
        {% if (i - wait % 60) % 60 == 0 %}
            RESPOND TYPE=command MSG="Waiting... Remain {(wait - i) // 60} hours before printing"
        {% endif %}
        SET_PIN PIN=LED VALUE=0
        G4 P58000
        SET_PIN PIN=LED VALUE=0.05
        G4 P2000
    {% endfor %}
    RESPOND TYPE=command MSG="Printing will continue right now"
    SET_PIN PIN=LED VALUE=0.25
