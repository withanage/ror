<script>

	$(document).ready(function () {ldelim}
		var mytest = "{$mytest}";
		console.log(mytest);
	let lang = 'en_US';
	//$('input[id^="affiliation-'+ lang+'"]').hide();
	$('input[id^="affiliation-'+ lang+'"]').tagit({ldelim}
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
							response($.map(data.items, function (item) {ldelim}
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
			$('input[id^="affiliation-fr_CA"]').val("reee");
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
	{rdelim});
</script>
