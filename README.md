# Schemas

A repository for all blinkbox books XML schemas, along with example messages.

## Guidelines

1. Maintain a folder structure which relates to the namespace.
    > the namespace:
    > `http://schemas.blinkboxbooks.com/events/clients/v1`
    > should be translated to the following directory:
    > `events/clients/v1`

2. Each directory should have **one** schema file called `schema.xsd`.
    > So from the previous example we would have:
    > `events/clients/v1/schema.xsd`

3. For each schema, you should create at least one example XML file in the same directory.
    > Continuing from our previous example:
    > `events/clients/v1/clientCreated.xml`
    > `events/clients/v1/clientUpdated.xml`
    > `events/clients/v1/clientDeleted.xml`

## Requirements

There is a small utility written in Ruby which validates all schemas against their respective examples.

This utility requires Ruby 2.0.0 or later and bundler.

Ensure you have bundler installed, as it is used to load dependencies:

```
$ gem install bundler
```

You can install all the dependencies using the `install` command:

```
$ bundle install
```

Make sure that the script is runnable:

```
$ chmod +x validate
```

## Running the validator

To validate all your XML schemas execute the the following command:

```
$ ./validate
```

You can see from the output:

* Each directory it visits
* Each XML it runs against each XSD
* Valid or invalid indicators along with any validation errors
* Whether a file was skipped
* File statistics

### Why a file was skipped?

The validator expects that on each directory there is only one `schema.xsd` and at least one example XML file to validate against the schema.

If there is a `schema.xsd` but there are no XML files, then it skips the validation for that file.

It is advised that you have at least one XML file for each `schema.xsd`, unless there are exceptional circumstances where there cannot be an XML to validate against that schema (e.g., the schema defines only attributes).
