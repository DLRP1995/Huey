Models
======

All models are specified in the configuration file ``models.json``, which you can customize. 
This file is located in your working directory. You can add new models provided directly by ``OpenAI API``
and those supported by ``Langchain`` to this file. Configuration for Langchain wrapper is placed in ``langchain`` key.

Adding custom LLMs via Langchain and Llama-index
-------------------------------------------------

To add a new model using the Langchain or Llama-index wrapper in **PyGPT**, insert the model's configuration details into the ``models.json`` file. This should include the model's name, its supported modes (either ``chat``, ``completion``, or both), the LLM provider (which can be either e.g. ``OpenAI`` or ``HuggingFace``), and, if you are using a ``HuggingFace`` model, an optional ``API KEY``.

Example of models configuration - ``models.json``:

.. code-block:: json

    "gpt-3.5-turbo": {
        "id": "gpt-3.5-turbo",
        "name": "gpt-3.5-turbo",
        "mode": [
            "chat",
            "assistant",
            "langchain",
            "llama_index"
        ],
        "langchain": {
            "provider": "openai",
            "mode": [
                "chat"
            ],
            "args": [
                {
                    "name": "model_name",
                    "value": "gpt-3.5-turbo",
                    "type": "str"
                }
            ],
            "env": [
                {
                    "name": "OPENAI_API_KEY",
                    "value": "{api_key}"
                }
            ]
        },
        "llama_index": {
            "provider": "openai",
            "mode": [
                "chat"
            ],
            "args": [
                {
                    "name": "model",
                    "value": "gpt-3.5-turbo",
                    "type": "str"
                }
            ],
            "env": [
                {
                    "name": "OPENAI_API_KEY",
                    "value": "{api_key}"
                }
            ]
        },
        "ctx": 4096,
        "tokens": 4096,
        "default": false
    },


There is built-in support for those LLMs providers:


* OpenAI (openai)
* Azure OpenAI (azure_openai)
* Google (google)
* HuggingFace (huggingface)
* Anthropic (anthropic)
* Ollama (ollama)


Using other models (non-GPT)
---------------------------

Llama 3, Mistral, and other local models
````````````````````````````````````````

How to use locally installed Llama 3 or Mistral models:

1) Choose a working mode: ``Chat with files`` or ``Langchain``.

2) On the models list - select, edit, or add a new model (with ``ollama`` provider). You can edit the model settings through the right mouse button click -> ``Edit``, then configure the model parameters in the ``advanced`` section.

3) Download and install Ollama from here: https://github.com/ollama/ollama

For example, on Linux:

.. code-block:: sh

    curl -fsSL https://ollama.com/install.sh | sh

4) Run the model (e.g. Llama 3) locally on your machine. For example, on Linux:

.. code-block:: sh

    ollama run llama3.1

5) Return to PyGPT and select the correct model from models list to chat with selected model using Ollama running locally.

**Example available models:**

- llama3.1
- codellama
- mistral
- llama2-uncensored

You can add more models by editing the models list.

**List of all models supported by Ollama:**

https://ollama.com/library

https://github.com/ollama/ollama

**IMPORTANT:** Remember to define the correct model name in the **kwargs list in the model settings.

Using local embedding models
````````````````````````````
Refer to: https://docs.llamaindex.ai/en/stable/examples/embeddings/ollama_embedding/

You can use an Ollama instance for embeddings. Simply select the ``ollama`` provider in:

.. code-block:: sh

    Config -> Settings -> Indexes (llama-index) -> Embeddings -> Embeddings provider

Define parameters like model name and Ollama base URL in the Embeddings provider **kwargs list, e.g.:

- name: ``model_name``, value: ``llama3.1``, type: ``str``

- name: ``base_url``, value: ``http://localhost:11434``, type: ``str``


Google Gemini and Anthropic Claude
``````````````````````````````````
To use ``Gemini`` or ``Claude`` models, select the ``Chat with files`` mode in PyGPT and select a predefined model.
Remember to configure the required parameters like API keys in the model ENV config fields (RMB click on the model name and select ``Edit``).

**Google Gemini**

Required ENV:

- GOOGLE_API_KEY

Required **kwargs:

- model

**Anthropic Claude**

Required ENV:

- ANTHROPIC_API_KEY

Required **kwargs:

- model


Adding custom LLM providers
---------------------------

Handling LLMs with Langchain and Llama-index is implemented through separated wrappers. This allows for the addition of support for any provider and model available via Langchain or Llama-index. All built-in wrappers for the models and its providers  are placed in the ``pygpt_net.provider.llms``.

These wrappers are loaded into the application during startup using ``launcher.add_llm()`` method:

.. code-block:: python

    # app.py

    from pygpt_net.provider.llms.openai import OpenAILLM
    from pygpt_net.provider.llms.azure_openai import AzureOpenAILLM
    from pygpt_net.provider.llms.anthropic import AnthropicLLM
    from pygpt_net.provider.llms.hugging_face import HuggingFaceLLM
    from pygpt_net.provider.llms.ollama import OllamaLLM
    from pygpt_net.provider.llms.google import GoogleLLM

    def run(**kwargs):
        """Runs the app."""
        # Initialize the app
        launcher = Launcher()
        launcher.init()

        # Register plugins
        ...

        # Register langchain and llama-index LLMs wrappers
        launcher.add_llm(OpenAILLM())
        launcher.add_llm(AzureOpenAILLM())
        launcher.add_llm(AnthropicLLM())
        launcher.add_llm(HuggingFaceLLM())
        launcher.add_llm(OllamaLLM())
        launcher.add_llm(GoogleLLM())

        # Launch the app
        launcher.run()

To add support for providers not included by default, you can create your own wrapper that returns a custom model to the application and then pass this custom wrapper to the launcher.

Extending PyGPT with custom plugins and LLM wrappers is straightforward:

- Pass instances of custom plugins and LLM wrappers directly to the launcher.

To register custom LLM wrappers:

- Provide a list of LLM wrapper instances as the ``llms`` keyword argument when initializing the custom app launcher.

**Example:**

.. code-block:: python

    # custom_launcher.py

    from pygpt_net.app import run
    from plugins import CustomPlugin, OtherCustomPlugin
    from llms import CustomLLM

    plugins = [
        CustomPlugin(),
        OtherCustomPlugin(),
    ]
    llms = [
        CustomLLM(),  # <--- custom LLM provider (wrapper)
    ]
    vector_stores = []

    run(
        plugins=plugins, 
        llms=llms, 
        vector_stores=vector_stores,
    )

**Examples (tutorial files)** 

See the ``examples`` directory in this repository with examples of custom launcher, plugin, vector store, LLM (Langchain and Llama-index) provider and data loader:

* ``examples/custom_launcher.py``
* ``examples/example_audio_input.py``
* ``examples/example_audio_output.py``
* ``examples/example_data_loader.py``
* ``examples/example_llm.py``  <-- use it as an example
* ``examples/example_plugin.py``
* ``examples/example_vector_store.py``
* ``examples/example_web_search.py``

These example files can be used as a starting point for creating your own extensions for **PyGPT**.

To integrate your own model or provider into **PyGPT**, you can also reference the classes located in the ``pygpt_net.provider.llms``. These samples can act as an more complex example for your custom class. Ensure that your custom wrapper class includes two essential methods: ``chat`` and ``completion``. These methods should return the respective objects required for the model to operate in ``chat`` and ``completion`` modes.

Every single LLM provider (wrapper) inherits from `BaseLLM` class and can provide 3 components: provider for Langchain, provider for Llama-index, and provider for Embeddings.


Adding custom Vector Store providers
------------------------------------

**From version 2.0.114 you can also register your own Vector Store provider**:

.. code-block:: python

    # app.py

    # vector stores
    from pygpt_net.provider.vector_stores.chroma import ChromaProvider
    from pygpt_net.provider.vector_stores.elasticsearch import ElasticsearchProvider
    from pygpt_net.provider.vector_stores.pinecode import PinecodeProvider
    from pygpt_net.provider.vector_stores.redis import RedisProvider
    from pygpt_net.provider.vector_stores.simple import SimpleProvider

    def run(**kwargs):
        # ...
        # register base vector store providers (llama-index)
        launcher.add_vector_store(ChromaProvider())
        launcher.add_vector_store(ElasticsearchProvider())
        launcher.add_vector_store(PinecodeProvider())
        launcher.add_vector_store(RedisProvider())
        launcher.add_vector_store(SimpleProvider())

        # register custom vector store providers (llama-index)
        vector_stores = kwargs.get('vector_stores', None)
        if isinstance(vector_stores, list):
            for store in vector_stores:
                launcher.add_vector_store(store)

        # ...

To register your custom vector store provider just register it by passing provider instance in ``vector_stores`` keyword argument:

.. code-block:: python

    # custom_launcher.py

    from pygpt_net.app import run
    from plugins import CustomPlugin, OtherCustomPlugin
    from llms import CustomLLM
    from vector_stores import CustomVectorStore

    plugins = [
        CustomPlugin(),
        OtherCustomPlugin(),
    ]
    llms = [
        CustomLLM(),
    ]
    vector_stores = [
        CustomVectorStore(),  # <--- custom vector store provider
    ]

    run(
        plugins=plugins,
        llms=llms,
        vector_stores=vector_stores,
    )