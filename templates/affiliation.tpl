<script>

	$(document).ready(function () {ldelim}
		var primaryLocale = "{$primaryLocale}";

		//$('input[id^="affiliation-'+ lang+'"]').hide();
		$('input[id^="affiliation-' + primaryLocale + '"]').tagit({ldelim}
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
			afterTagAdded: function (event, ui) {ldelim}
				console.log("afterTagAdded ", ui);
				if (ui.duringInitialization === true) {

					$('input[id^="affiliation-' + primaryLocale + '"]').after('<div id = "rorIdField" style="float:right; background:#eaedee">{$rorId}</div>');
				} else {
					{foreach from=$supportedLocales key=locale item=v}

					console.log("{$locale}");
					{/foreach}
				}
				{rdelim},
			afterTagRemoved: function (event, ui) {ldelim}
				console.log("afterTagRemoved ", ui);
				$('#rorIdField').remove("");
				{rdelim},
			onTagClicked: function (event, ui) {ldelim}
				console.log("onTagClicked ", ui);
				{rdelim},
			onTagRemoved: function (event, ui) {ldelim}
				console.log("onTagClicked ", ui);
				$('#rorIdField').remove("");
				{rdelim}
			{rdelim});
		{rdelim});
</script>
