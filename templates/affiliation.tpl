<script>

	$(document).ready(function () {ldelim}

		$('input[id^="affiliation-en_US"]').tagit({ldelim}
				fieldName: 'affiliation-ROR-en_US[]',
				allowSpaces: true,
				tagLimit: 1,
				tagSource: function(search, response){ldelim}
					$.ajax({ldelim}
						url: 'https://api.crossref.org/funders',
						dataType: 'json',
						cache: true,
						data: {ldelim}
							query: search.term + '*'
							{rdelim},
						success:
								function( data ) {ldelim}
									var output = data.message.items;
									console.log(output);
								{rdelim}
					{rdelim});
				{rdelim}
		{rdelim});
	{rdelim});
</script>
