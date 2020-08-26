<script>

	$(document).ready(function () {ldelim}

		$('input[id^="affiliation-en_US"]').tagit({ldelim}
				fieldName: 'affiliation-ROR-en_US[]',
				allowSpaces: true,
				tagLimit: 1,
				tagSource: function(search, response){ldelim}
					$.ajax({ldelim}
						url: 'https://api.ror.org/organizations',
						dataType: 'json',
						cache: true,
						data: {ldelim}
							affiliation: search.term + '*'
							{rdelim},
						success:
								function( data ) {ldelim}
									var output = data.items;
									console.log(output);
									response($.map(output, function(item) {ldelim}
										return {ldelim}
											label: item.organization.name,
											value: item.organization.name
											{rdelim}
									{rdelim}));

								{rdelim}
					{rdelim});
				{rdelim}
		{rdelim});
	{rdelim});
</script>
