---
# You don't need to edit this file, it's empty on purpose.
# Edit theme's home layout instead if you wanna make some changes
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: home
---


<div class="d-flex justify-content-center">
    <div class="info-container">
        <div class="info-summary d-flex flex-wrap">
            <div class="info-label-long left-bar">COTABATO</div>
            <div class="progress-bar-container flex-grow-1">
                <div class="progress-bar-inner horizontal">
                    <div class="progress-bar-track">
                        <div class="progress-bar-fill">
                            <span>{{ site.data.all.all }}%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="spacer-h"></div>

        <div class="info-detail d-flex align-items-start">
            <div class="info-label-long-proxy"></div>
            <div class="d-md-flex flex-md-row">
                <div class="info-block d-flex flex-row">
                    <div class="info-label left-bar">Current</div>
                    <div class="info-value-number middle-bar divider-bar-right">{{ site.data.all.total.count }}</div>
                    <div class="info-value-percent right-bar">{{ site.data.all.total.percent }}%</div>
                </div>

                <div class="spacer-w"></div>

                <div class="info-block d-flex flex-row">
                    <div class="info-label left-bar">Target</div>
                    <div class="info-value-number middle-bar divider-bar-right">150,000</div>
                    <div class="info-value-percent right-bar">67%</div>
                </div>

                <div class="spacer-w"></div>

                <div class="info-block d-flex flex-row">
                    <div class="info-label left-bar">Total</div>
                    <div class="info-value-number right-bar">225,000</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="spacer-h50"></div>

{% for district in site.data.districts %}
<div class="d-flex justify-content-center">
    <div class="info-container">
        <div class="info-summary d-flex flex-wrap">
            <div class="info-label-long left-bar">{{ district.name }}</div>
            <div class="progress-bar-container flex-grow-1">
                <div class="progress-bar-inner horizontal">
                    <div class="progress-bar-track">
                        <div class="progress-bar-fill">
                            <span>{{ site.data.all.all }}%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="spacer-h"></div>

        <div class="info-detail d-flex align-items-start">
            <div class="info-label-long-proxy"></div>
            <div class="d-md-flex flex-md-row">
                <div class="info-block d-flex flex-row">
                    <div class="info-label left-bar">Current</div>
                    <div class="info-value-number middle-bar divider-bar-right">{{ site.data.all.total.count }}</div>
                    <div class="info-value-percent right-bar">{{ site.data.all.total.percent }}%</div>
                </div>

                <div class="spacer-w"></div>

                <div class="info-block d-flex flex-row">
                    <div class="info-label left-bar">Target</div>
                    <div class="info-value-number middle-bar divider-bar-right">150,000</div>
                    <div class="info-value-percent right-bar">67%</div>
                </div>

                <div class="spacer-w"></div>

                <div class="info-block d-flex flex-row">
                    <div class="info-label left-bar">Total</div>
                    <div class="info-value-number right-bar">225,000</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="spacer-h50"></div>
{% endfor %}
