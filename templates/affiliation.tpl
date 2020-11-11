<script>

	$(document).ready(function () {ldelim}
		var primaryLocale = "{$primaryLocale}";

	//$('input[id^="affiliation-'+ lang+'"]').hide();
	$('input[id^="affiliation-'+ primaryLocale+'"]').tagit({ldelim}
		fieldName: 'affiliation-ROR[]',
		allowSpaces: true,
		uiLimit: 1,
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
		afterTagAdded: function(event, ui) {ldelim}
			console.log("afterTagAdded ",ui);
			if (!ui.duringInitialization === true) {
				{foreach from=$supportedLocales key=locale item=v}
				$('input[id^="affiliation-fr_CA"]').val("{$locale}");
				console.log("{$locale}");
				{/foreach}
			}
			{rdelim},
		afterTagRemoved: function(event, ui) {ldelim}
			console.log("afterTagRemoved ",ui);
			{rdelim},
		onTagClicked: function(event, ui) {ldelim}
			console.log("onTagClicked ",ui);
			{rdelim},
		onTagRemoved: function(event, ui) {ldelim}
			console.log("onTagClicked ",ui);
			{rdelim}
		{rdelim});
	{rdelim});
</script>
