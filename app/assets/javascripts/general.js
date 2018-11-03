$(function() {
	$('#selectAll').click(function() {
		var item = $('#list .tf');

		if($(this).prop('checked')) {
			item.prop('checked', true);
		} else {
			item.prop('checked', false);
		}
	});

	$('.cargando').dialog({
		autoOpen: false,
		modal: true,
		resizable: false,
		height: 140,
	});
});
