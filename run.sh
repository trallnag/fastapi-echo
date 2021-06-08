#!/usr/bin/env bash

project_name="hello_world"


# ==============================================================================
# Misc


function _lint {
    poetry run flake8 --config .flake8 --statistics
    poetry run mypy ${project_name} --allow-redefinition
}

function _requirements {
    rm -rf "requirements.txt"
    poetry export \
        --format "requirements.txt" \
        --output "requirements.txt" \
        --without-hashes
}

function _uvicorn_reload {
    poetry run uvicorn ${project_name}.main:app --reload
}


# ==============================================================================
# Format


function _format_style {
    poetry run black .    
}

function _format_imports {
    poetry run isort --profile black .
}

function _format {
    _format_style
    _format_imports
}


# ==============================================================================
# Test


function _test {
    poetry run pytest --cov=./ --cov-report=xml
}


# ==============================================================================


function _help {
    cat << EOF
Functions you can use like this 'bash run.sh <function name>':
    lint
    requirements
    uvicorn-reload
    format-style
    format-imports
    format
    test
EOF
}

if [[ $# -eq 0 ]]
then
    _help
fi

for arg in "$@"
do
    if  [ $arg = "help" ] || [ $arg = "-help" ] || [ $arg = "--help" ]; then _help
    elif [ $arg = "lint" ]; then _lint
    elif [ $arg = "requirements" ]; then _requirements
    elif [ $arg = "uvicorn-reload" ]; then _uvicorn_reload
    elif [ $arg = "format-style" ]; then _format_style
    elif [ $arg = "format-imports" ]; then _format_imports
    elif [ $arg = "format" ]; then _format
    elif [ $arg = "test" ]; then _test
    else _help
    fi
done


# ==============================================================================
