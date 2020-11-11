<script>

	$(document).ready(function () {ldelim}
		// $('<input>').attr({
		// 	type: 'hidden',
		// 	id: 'affiliation-ROR-ID',
		// 	name: 'bar'
		// }).appendTo('form');

		{rdelim});
	$('input[id^="affiliation-en_US"]').tagit({ldelim}
		itemName: 'affiliation-ROR',
		fieldName: 'affiliation-ROR[]',
		allowSpaces: true,
		tagLimit: 1,
		tagSource: function (search, response) {ldelim}
			$.ajax({ldelim}
				url: 'https://api.ror.org/organizations',
				dataType: 'json',
				cache: true,
				data: {ldelim}
					affiliation: search.term + '*'
					{rdelim},
				success:
						function (data) {ldelim}
							let output = data.items;
							console.log(output);
							response($.map(output, function (item) {ldelim}
								return {ldelim}
									label: item.organization.name,
									value: item.organization.name + ' [' + item.organization.id + ']'
									{rdelim}
								{rdelim}));

							{rdelim}
				{rdelim});
			{rdelim},
		afterTagAdded: function(event, tag) {ldelim}
			console.log("afterTagAdded ",tag);
			{rdelim},
		afterTagRemoved: function(event, tag) {ldelim}
			console.log("afterTagRemoved ",tag);
			{rdelim},
		onTagClicked: function(event, tag) {ldelim}
			console.log("onTagClicked ",tag);
			{rdelim},
		onTagRemoved: function(event, tag) {ldelim}
			console.log("onTagClicked ",tag);
			{rdelim}
		{rdelim});
</script>
