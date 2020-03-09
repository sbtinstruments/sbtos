SEC_OVERVIEW = f"""
<h1>Overview</h1>
<p>
	The software distribution used in this device (<em>"sbtOS"</em>) is an aggregate of separate
	programs.
	<br>
	The programs from the aggregate are put into two categories:
</p>
<ol>
	<li>Programs with a proprietary license (<em>"Proprietary Software"</em>)</li>
	<li>Programs with a non-proprietary license (<em>"Non-proprietary Software"</em>) </li>
</ol>
<p>
	<em>sbtOS</em> is built using the Buildroot build system (<em>"Buildroot"</em>) by
	Peter Korsgaard and others. The specific configuration of <em>Buildroot</em> that is
	used to build <em>sbtOS</em> can be found in the source code repository
	(the <em>"sbtOS Repository"</em>) at the following URL:
	<br><br>
	https://github.com/sbtinstruments/sbtos
	<br><br>
	The <em>sbtOS Repository</em> contains software that can be used to:
</p>
<ul>
	<li>
		Retrieve the source code of <em>Buildroot</em> and the
		<em>Non-proprietary Software</em>
	</li>
	<li>
		Build the <em>Non-proprietary Software</em> from the source code
	</li>
	<li>
		Bundle together a software distribution that can be used on this device
	</li>
</ul>
<p>
	SBT Instruments A/S owns the copyright (c) to <em>sbtOS</em> and the
	<em>Proprietary Software</em>. The copyright (c) of <em>Buildroot</em> and
	the <em>Non-proprietary Software</em> belongs to their respective owners
	(see the Acknowledgements section).
</p>
"""

SEC_ACKNOWLEDGEMENTS = """
<h1>Acknowledgements</h1>

<h2><em>Proprietary Software</em></h2>
<p>
	Portions of the <em>Proprietary Software</em> may utilize the following copyrighted material,
	the use of which is hereby acknowledged.
</p>

{prop_acks}

<h2><em>Non-proprietary Software</em></h2>

{nonprop_acks}
"""

