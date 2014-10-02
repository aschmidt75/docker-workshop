echo == Ensure fig is installed
PIP_=$(which pip)
if [[ -z $PIP_ ]]; then
	sudo apt-get -yqq install python-pip
fi
pip --version
FIG_=$(which fig)
if [[ -z $FIG_ ]]; then
	pip install fig
fi
fig --version
