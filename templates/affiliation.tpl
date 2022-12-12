<script>

	$(document).ready(function () {ldelim}
		var primaryLocale = "{$primaryLocale}";
		var results = null;
		const tagitInput = '.tagit-new > input';
		const rorPlaceHolder = "Search ror.org";

		var mainAffiliation = 'input[id^="affiliation-' + primaryLocale + '"]';
		if ( !$( mainAffiliation ).length ) {
			mainAffiliation = 'input[id^="affiliation-"]';
		}

		$(mainAffiliation).tagit({ldelim}
			fieldName: 'affiliation-ROR[]',
			allowSpaces: true,
			tagLimit: 1,
			tagSource: function (search, r) {ldelim}
				$.ajax({ldelim}
					url: 'https://api.ror.org/organizations',
					dataType: 'json',
					cache: true,
					data: {ldelim}
						affiliation: search.term + '*'
						{rdelim},
					success:
							function (data) {ldelim}
								results = data.items;
								console.log('data.items', data.items);
								r($.map(data.items, function (item) {ldelim}
									return {ldelim}
										label: item.organization.name,
										value: item.organization.name + ' [' + item.organization.id + ']'
										{rdelim}
									{rdelim}));

								{rdelim}
					{rdelim});
				{rdelim},
			beforeTagAdded: function (event,ui) {ldelim}
				{rdelim},
			afterTagAdded: function (event, ui) {ldelim}
				if (ui.duringInitialization === true) {
					$(mainAffiliation).after('<div id = "rorIdField" style="float:right; background:#eaedee;"><a href="{$rorId}" target="_blank">{$rorId}</a></div>');

				} else {
					const regex = /https:\/\/ror\.org\/(\d|\w)+/g;
					const found = ui.tagLabel.match(regex);
					console.log("ui",ui);
					if (found !== null) {
						console.log(found);
						const rorId = found[0];
						$.each(results, function (key,value){
							console.log(key, value);
							if (value.organization.id == rorId){
								var supportedLocales = {$supportedLocales|json_encode};
								console.log("supportedLocales", supportedLocales);
								$.each(supportedLocales, function( k, val ) {
									var locale = k.slice(0,2);
									if (locale.length == 2) {
										value.organization.labels.forEach(function (v) {
											if (locale == v["iso639"]) {
												if (locale !== primaryLocale.slice(0,2)) {
													$('input[id^="affiliation-' + locale + '"]').val(v.label);
													$('input[id^="affiliation-' + locale + '"]').parent().css("display", "block");
													$('input[id^="affiliation-' + locale + '"]').parent().css("width", "576px");
												}
											}
										});

									}
								});

							}
						});

					}


				}
				console.log("afterTagAdded");
				{rdelim},
			afterTagRemoved: function (event, ui) {ldelim}
				$('#rorIdField').remove("");
				$('input[id^="affiliation-').val("");
				$('.localization_popover').css("display", "hidden");
				$(tagitInput).attr("placeholder", rorPlaceHolder);
				{rdelim},
			onTagClicked: function (event, ui) {ldelim}
				$(tagitInput).attr("placeholder", rorPlaceHolder);
				{rdelim},
			onTagRemoved: function (event, ui) {ldelim}
				$('#rorIdField').remove("");
				$('input[id^="affiliation-').val("");
				$('.localization_popover').css("display", "hidden");
				$(tagitInput).attr("placeholder", rorPlaceHolder);
				{rdelim}
			{rdelim});
		if($('.tagit-label').val() || $('.tagit-label').length==0 ) {
			$(tagitInput).attr("placeholder", rorPlaceHolder);
		}
		{rdelim});
</script>
