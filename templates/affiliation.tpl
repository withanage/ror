<script>

	$(document).ready(function () {ldelim}



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
										value: item.organization.name
										{rdelim}
									{rdelim}));

								{rdelim}
					{rdelim});
				{rdelim},
			afterTagAdded: function(event, tag) {ldelim}
				console.log()
				{rdelim},
			afterTagRemoved: function(event, tag) {ldelim}
				{rdelim},
			onTagClicked: function(event, tag) {ldelim}
				{rdelim},
			onTagRemoved: function(event, tag) {ldelim}
				{rdelim}
			{rdelim});

		{rdelim});
</script>
