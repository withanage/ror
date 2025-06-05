<h2 class="pkp_screen_reader">{translate key="submission.authors"}</h2>
<ul class="versions authors">
    {foreach from=$publication->getData('authors') item=author}
        <li>
            <span class="name">
                {$author->getFullName()|escape}
            </span>
            {if $author->getLocalizedData('affiliation')}
                <span class="affiliation">
                    {$author->getLocalizedData('affiliation')|escape}
                    {if $author->getData('rorId')}
                        <a href="{$author->getData('rorId')|escape}">{$rorIdIcon}</a>
                    {/if}
                </span>
            {/if}
            {if $author->getData('orcid')}
                <span class="orcid">
                    {if $author->getData('orcidAccessToken')}
                        {$orcidIcon}
                    {/if}
                    <a href="{$author->getData('orcid')|escape}" target="_blank">
                        {$author->getData('orcid')|escape}
                    </a>
                </span>
            {/if}
        </li>
    {/foreach}
</ul>