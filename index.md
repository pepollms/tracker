---
# You don't need to edit this file, it's empty on purpose.
# Edit theme's home layout instead if you wanna make some changes
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: home
---


<div class="d-flex flex-wrap justify-content-left">

<div class="block flex-column flex-grow-1">
    <div class="spacer-h"></div>
    <div id="summary_title" class="info-label-full height-summary bg-label container rounded-top flex-grow-1">
        <div class="font-size-summary font-weight-bold text-uppercase text-left text-align-middle">{{ site.data.province.name }}</div>
    </div>
    <div class="fix-spacer-h2"></div>
    <div id="summary_progress_bar" class="progress height-summary rounded-bottom-left rounded-bottom-right rounded-0">
        <div class="progress-bar" role="progressbar" aria-valuenow="{{ site.data.all.total.current_percentage }}" valuemin="0" valuemax="100" style="width:{{ site.data.all.total.current_percentage }}%">
            <span class="font-size-summary-percent font-weight-bold">{{ site.data.all.total.current_percentage }}%</span>
        </div>
    </div>
    <div class="fix-spacer-h"></div>
</div>

<div class="spacer-w2"></div>

<div class="block d-flex">
    <div class="block">
        <div class="spacer-h"></div>
        <div class="info-label-pv height-summary bg-label rounded-top">
            <div class="font-size-summary font-weight-normal text-center text-align-middle">Current</div>
        </div>
        <div class="fix-spacer-h2"></div>
        <div class="block height-summary d-flex">
            <div class="info-value-number rounded-bottom-left">
                <div class="font-size-summary font-weight-bold text-center text-align-middle">{{ site.data.all.total.current_count }}</div>
            </div>
            <div class="spacer-w2"></div>
            <div class="info-value-percent rounded-bottom-right">
                <div class="font-size-summary-percent font-weight-bold text-center text-align-middle">{{ site.data.all.total.current_percentage }}%</div>
            </div>
        </div>
        <div class="fix-spacer-h"></div>
    </div>

    <div class="spacer-w2"></div>

    <div class="block">
        <div class="spacer-h"></div>
        <div class="info-label-pv height-summary bg-label rounded-top">
            <div class="font-size-summary font-weight-normal text-center text-align-middle">Target</div>
        </div>
        <div class="fix-spacer-h2"></div>
        <div class="block height-summary d-flex">
            <div class="info-value-number rounded-bottom-left">
                <div class="font-size-summary font-weight-bold text-center text-align-middle">{{ site.data.all.total.target_count }}</div>
            </div>
            <div class="spacer-w2"></div>
            <div class="info-value-percent rounded-bottom-right">
                <div class="font-size-summary-percent font-weight-bold text-center text-align-middle">{{ site.data.all.total.target_percentage }}%</div>
            </div>
        </div>
        <div class="fix-spacer-h"></div>
    </div>

    <div class="spacer-w2"></div>

    <div class="block">
        <div class="spacer-h"></div>
        <div class="info-label-value height-summary bg-label rounded-top">
            <div class="font-size-summary font-weight-normal text-center text-align-middle">Total</div>
        </div>
        <div class="fix-spacer-h2"></div>
        <div class="info-value-number height-summary rounded-bottom">
            <div class="font-size-summary font-weight-bold text-center text-align-middle">{{ site.data.all.total.total_voters }}</div>
        </div>
        <div class="fix-spacer-h"></div>
    </div>
</div>

</div>



<div class="fix-spacer-h"></div>



{% for district in site.data.districts %}
<div class="d-flex flex-wrap justify-content-left">
<div id="detail_left_content" class="block d-flex flex-grow-1">
    <div class="info-label-long height-detail bg-label container rounded-left">
        <div class="font-size-detail font-weight-bold text-uppercase text-left text-align-middle"><a href="{{ site.baseurl }}/districts/district_{{ district.district_id }}.html" class="geo_link">{{ district.district }}</a></div>
    </div>
    <div class="spacer-w2"></div>
    <div class="progress height-detail flex-grow-1 rounded-0 rounded-top-right rounded-bottom-right">
        <div class="progress-bar rounded-0 rounded-top-right rounded-bottom-right" role="progressbar" aria-valuenow="{{ district.current_percentage }}" valuemin="0" valuemax="100" style="width:{{ district.current_percentage }}%">
            <span class="font-size-detail-percent font-weight-bold">{{ district.current_percentage }}%</span>
        </div>
    </div>
</div>

<div class="spacer-w2"></div>

<div class="block d-flex">
    <div class="block flex-column">
        <div class="block height-detail d-flex flex-row">
            <div class="info-value-number rounded-top-left rounded-bottom-left">
                <div class="font-size-detail font-weight-bold text-center text-align-middle">{{ district.current_count }}</div>
            </div>
            <div class="spacer-w2"></div>
            <div class="info-value-percent rounded-top-right rounded-bottom-right">
                <div class="font-size-detail-percent font-weight-bold text-center text-align-middle">{{ district.current_percentage }}%</div>
            </div>
        </div>
    </div>

    <div class="spacer-w2"></div>

    <div class="block flex-column">
        <div class="block height-detail d-flex flex-row">
            <div class="info-value-number rounded-top-left rounded-bottom-left">
                <div class="font-size-detail font-weight-bold text-center text-align-middle">{{ district.target_count }}</div>
            </div>
            <div class="spacer-w2"></div>
            <div class="info-value-percent rounded-top-right rounded-bottom-right">
                <div class="font-size-detail-percent font-weight-bold text-center text-align-middle">{{ district.target_percentage }}%</div>
            </div>
        </div>
    </div>

    <div class="spacer-w2"></div>

    <div class="block flex-column">
        <div class="info-value-number height-detail rounded">
            <div class="font-size-detail font-weight-bold text-center text-align-middle">{{ district.total_voters }}</div>
        </div>
    </div>
</div>
</div>

<div class="collapsible-vertical-spacer"></div>
{% endfor %}
