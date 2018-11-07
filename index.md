---
# You don't need to edit this file, it's empty on purpose.
# Edit theme's home layout instead if you wanna make some changes
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: home
---


<div class="d-flex flex-wrap justify-content-center">

<div class="block flex-column">
    <div class="spacer-h"></div>
    <div class="info-label-full height-50 rounded-top container">
        <div class="font-size-28 font-weight-bold text-uppercase text-align-left text-align-middle">COTABATO</div>
    </div>
    <div class="spacer-h"></div>
    <div class="progress height-50">
        <div class="progress-bar" role="progressbar" aria-valuenow="{{ site.data.all.total.percent }}" valuemin="0" valuemax="100" style="width:{{ site.data.all.total.percent }}%">
            <span class="font-size-20 font-weight-bold">{{ site.data.all.total.percent }}%</span>
        </div>
    </div>
    <div class="fix-spacer-h"></div>
</div>

<div class="spacer-w"></div>

<div class="block">
    <div class="spacer-h"></div>
    <div class="info-label-pv height-50 rounded-top">
        <div class="font-size-28 font-weight-bold text-align-center text-align-middle">Current</div>
    </div>
    <div class="spacer-h"></div>
    <div class="block height-50 d-flex">
        <div class="info-value-number rounded-bottom-left">
            <div class="font-size-28 font-weight-bold text-align-center text-align-middle">{{ site.data.all.total.count }}</div>
        </div>
        <div class="spacer-w2"></div>
        <div class="info-value-percent rounded-bottom-right">
            <div class="font-size-28 font-weight-bold text-align-center text-align-middle">{{ site.data.all.total.percent }}%</div>
        </div>
    </div>
    <div class="fix-spacer-h"></div>
</div>

<div class="spacer-w"></div>

<div class="block">
    <div class="spacer-h"></div>
    <div class="info-label-pv height-50 rounded-top">
        <div class="font-size-28 font-weight-bold text-align-center text-align-middle">Target</div>
    </div>
    <div class="spacer-h"></div>
    <div class="block height-50 d-flex">
        <div class="info-value-number rounded-bottom-left">
            <div class="font-size-28 font-weight-bold text-align-center text-align-middle">{{ site.data.all.total.count }}</div>
        </div>
        <div class="spacer-w2"></div>
        <div class="info-value-percent rounded-bottom-right">
            <div class="font-size-28 font-weight-bold text-align-center text-align-middle">{{ site.data.all.total.percent }}%</div>
        </div>
    </div>
    <div class="fix-spacer-h"></div>
</div>

<div class="spacer-w"></div>

<div class="block">
    <div class="spacer-h"></div>
    <div class="info-label-value height-50 rounded-top">
        <div class="font-size-28 font-weight-bold text-align-center text-align-middle">Total</div>
    </div>
    <div class="spacer-h"></div>
    <div class="info-value-number height-50 rounded-bottom">
        <div class="font-size-28 font-weight-bold text-align-center text-align-middle">{{ site.data.all.total.count }}</div>
    </div>
    <div class="fix-spacer-h"></div>
</div>

</div>



<div class="fix-spacer-h"></div>
<div class="fix-spacer-h"></div>



{% for district in site.data.districts %}

<div class="d-flex flex-wrap justify-content-center">

<div class="block flex-column">
    <div class="spacer-h"></div>
    <div class="info-label-full height-40 rounded-top container">
        <div class="font-size-24 font-weight-bold text-uppercase text-align-left text-align-middle">{{ district.name }}</div>
    </div>
    <div class="spacer-h"></div>
    <div class="progress height-40">
        <div class="progress-bar" role="progressbar" aria-valuenow="{{ site.data.all.total.percent }}" valuemin="0" valuemax="100" style="width:{{ site.data.all.total.percent }}%">
            <span class="font-size-24 font-weight-bold">{{ site.data.all.total.percent }}%</span>
        </div>
    </div>
    <div class="fix-spacer-h"></div>
</div>

<div class="spacer-w"></div>

<div class="block">
    <div class="spacer-h"></div>
    <div class="info-label-pv height-40 rounded-top">
        <div class="font-size-24 font-weight-bold text-align-center text-align-middle">Current</div>
    </div>
    <div class="spacer-h"></div>
    <div class="block height-40 d-flex">
        <div class="info-value-number rounded-bottom-left">
            <div class="font-size-24 font-weight-bold text-align-center text-align-middle">{{ site.data.all.total.count }}</div>
        </div>
        <div class="spacer-w2"></div>
        <div class="info-value-percent rounded-bottom-right">
            <div class="font-size-24 font-weight-bold text-align-center text-align-middle">{{ site.data.all.total.percent }}%</div>
        </div>
    </div>
    <div class="fix-spacer-h"></div>
</div>

<div class="spacer-w"></div>

<div class="block">
    <div class="spacer-h"></div>
    <div class="info-label-pv height-40 rounded-top">
        <div class="font-size-24 font-weight-bold text-align-center text-align-middle">Target</div>
    </div>
    <div class="spacer-h"></div>
    <div class="block height-40 d-flex">
        <div class="info-value-number rounded-bottom-left">
            <div class="font-size-24 font-weight-bold text-align-center text-align-middle">{{ site.data.all.total.count }}</div>
        </div>
        <div class="spacer-w2"></div>
        <div class="info-value-percent rounded-bottom-right">
            <div class="font-size-24 font-weight-bold text-align-center text-align-middle">{{ site.data.all.total.percent }}%</div>
        </div>
    </div>
    <div class="fix-spacer-h"></div>
</div>

<div class="spacer-w"></div>

<div class="block">
    <div class="spacer-h"></div>
    <div class="info-label-value height-40 rounded-top">
        <div class="font-size-24 font-weight-bold text-align-center text-align-middle">Total</div>
    </div>
    <div class="spacer-h"></div>
    <div class="info-value-number height-40 rounded-bottom">
        <div class="font-size-24 font-weight-bold text-align-center text-align-middle">{{ site.data.all.total.count }}</div>
    </div>
    <div class="fix-spacer-h"></div>
</div>

</div>

{% endfor %}
