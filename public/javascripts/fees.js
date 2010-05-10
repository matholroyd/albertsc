var new_member = null;
var category = null;
var adults = null;
var children = null;		
var items = null;
var top_racks = 0;
var middle_racks = 0;
var bottom_racks = 0;
var minnow_racks = 0;

function category_and_family_setup() {
    var result = category != null;
    if(result) {
        $('#racking_fees').show();
    } else {
        $('#racking_fees').hide();
    }
    return result;
}

function racking_choosen() {
    return top_racks != null && middle_racks != null && bottom_racks != null && minnow_racks != null;
}

function top_rack_fees() {
	return 115 * top_racks;
}

function middle_rack_fees() {
	return 150 * middle_racks;
}

function bottom_rack_fees() {
	return 190 * bottom_racks;
}

function minnow_rack_fees() {
	return 75 * minnow_racks;
}

function racking_fees() {
    return top_rack_fees() + middle_rack_fees() + bottom_rack_fees() + minnow_rack_fees();
}

function joining_fee() {
	if(new_member) {
		switch(category) {
			case 'family':
			case 'senior':
			case 'corporate':
				return 75;
			case 'junior':
			case 'student':
			case 'pensioner':
				return 30;
			case 'associate':
				return 10;
		}
	} else {
		return 0;
	}
}

function annual_subcription() {
	switch(category) {
		case 'family':
			return 360;
		case 'corporate':
			return 360;
		case 'senior':
			return 235;
		case 'junior':
			return 100;
		case 'student':
			return 150;
		case 'pensioner':
			return 150;
		case 'associate':
			return 50;
	}
}

function caltotal() {		  
	if(new_member != null && category_and_family_setup() && racking_choosen()) {
		var total = 0;
        var description = "";

		total += joining_fee();
		total += annual_subcription();
		total += racking_fees();
				
		if(new_member) {
		  description = 'joining ($' + joining_fee() + ') + ';
        } else {
            description = '';
        }

        description += category + ' ($' + annual_subcription() + ')';

        if(top_racks > 0) {
            description += ' + ' + top_racks + ' top ($' + top_rack_fees() + ')';
        }

        if(middle_racks > 0) {
            description += ' + ' + middle_racks + ' middle ($' + middle_rack_fees() + ')';
        }

        if(bottom_racks > 0) {
            description += ' + ' + bottom_racks + ' bottom ($' + bottom_rack_fees() + ')';
        }

        if(minnow_racks > 0) {
            description += ' + ' + minnow_racks + ' minnow ($' + minnow_rack_fees() + ')';
        }
				
		$('#total_output').html('$' + total);
		$('#total_description').html(description);
		$('#payal_button').show();
		$('#paypal_item_name').val(description);
		$('#paypal_value').val(total);
	} else {
		$('#total_output').html('(waiting for selections)');
		$('#total_description').html('');
		$('#payal_button').hide();
	}
}

function set_nm(nm) {
	new_member = nm;
	$('#member_category').show();
	caltotal();
}

function set_cat(c) {
	category = c;
	caltotal();
}

function set_rack_top(tr) {
  top_racks = tr;
  caltotal();
}

function set_rack_middle(tr) {
  middle_racks = tr;
  caltotal();
}

function set_rack_bottom(tr) {
  bottom_racks = tr;
  caltotal();
}

function set_rack_minnow(tr) {
  minnow_racks = tr;
  caltotal();
}
