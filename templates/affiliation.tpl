<script>

	$(document).ready(function () {ldelim}

		let rorInput = $("<input type='text' value='' />")
				.attr("id", "affiliation-ROR2")
				.attr("name", "affiliation-ROR2[]");

		$('input[id^="affiliation-en_US"]').after(rorInput);

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
								var output = data.items;
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
			onTagClicked: function(event, tag) {ldelim}
				{rdelim},
			onTagRemoved: function(event, tag) {ldelim}
				{rdelim}
			{rdelim});

		{rdelim});
</script>
