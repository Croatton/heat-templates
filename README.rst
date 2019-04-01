====================
Mk.XX Heat templates
====================

OpenStack Heat templates for Mk-based cloud for training and development.

Usage
=====

Prepare python virtualenv with required clients:

.. code-block:: bash

   apt-get install python-virtualenv python-pip
   virtualenv --no-site-packages osvenv
   source osvenv/bin/activate
   pip install -r requirements.txt

Create `keystonerc` file for your OpenStack endpoint, for example use
following for DC in Czech Republic. Just fill in the username, password and
tenant name.

.. code-block:: bash

    export OS_USERNAME=
    export OS_PASSWORD=
    export OS_TENANT_NAME=
    export OS_AUTH_URL=https://vpc.tcpisek.cz:5000/v2.0
    export OS_AUTH_STRATEGY=keystone

Souce rc file and create heat stack.

.. code-block:: bash

    source osvenv/bin/activate
    source ./keystonerc
    ./stack.sh create template_name env_name stack_name

For example to deploy advanced lab to tcpisek environment with name `lab01` use
following code.

.. code-block:: bash

    source ./keystonerc
    ./stack.sh create mk20_lab_advanced tcpisek lab01

To validate stack before creating, source rc file and use the following code
(the first two arguments are the same as for ./create_stack.sh):

.. code-block:: bash

    source ./keystonerc
    ./stack.sh validate mk20_lab_advanced tcpisek lab01

To delete heat stack `lab01`.

.. code-block:: bash

    source ./keystonerc
    ./stack.sh delete really delete lab01
