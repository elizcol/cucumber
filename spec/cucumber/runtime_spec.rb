require 'spec_helper'

module Cucumber
describe Runtime do
  subject { Runtime.new(options) }
  let(:options)     { {} }

  describe "#features_paths" do
    let(:options) { {:paths => ['foo/bar/baz.feature', 'foo/bar/features/baz.feature', 'other_features'] } }
    it "returns the value from configuration.paths" do
      subject.features_paths.should == options[:paths]
    end
  end

  describe "#configure" do
    let(:support_code)      { double(Runtime::SupportCode).as_null_object }
    let(:results)           { double(Runtime::Results).as_null_object     }
    let(:new_configuration) { double('New configuration')}
    before(:each) do
      Runtime::SupportCode.stub(:new => support_code)
      Runtime::Results.stub(:new => results)
    end

    it "tells the support_code and results about the new configuration" do
      support_code.should_receive(:configure).with(new_configuration)
      results.should_receive(:configure).with(new_configuration)
      subject.configure(new_configuration)
    end

    it "replaces the existing configuration" do
      # not really sure how to test this. Maybe we should just expose
      # Runtime#configuration with an attr_reader?
      some_new_paths = ['foo/bar', 'baz']
      new_configuration.stub(:paths => some_new_paths)
      subject.configure(new_configuration)
      subject.features_paths.should == some_new_paths
    end

    it '#doc_string' do
      subject.doc_string('Text').should == 'Text'
    end
  end
    
  def check_gherkin(str)
      res = subject.gherkinise(MultiJson.load(str.to_s))
      puts res
      res
  end
  
  it "should convert ruby hash of json feature to gherkin feature" do
    check_gherkin(%{
            {
              "id": "one",
              "uri": "test.feature",
              "keyword": "Feature",
              "name": "One",
              "description": "Test \"quotes\"",
              "line" : 3
            }
          }).should == "Feature: One"
   end

  it "should convert ruby hash of complex json feature to gherkin feature" do
    check_gherkin(%{
    {
              "uri": "test.feature",
              "description": "",
              "elements": [
                {
                  "description": "",
                  "keyword": "Scenario",
                  "line": 4,
                  "id": "oh-hai;fujin",
                  "name": "Fujin",
                  "steps": [
                    {
                      "keyword": "Given ",
                      "line": 5,
                      "name": "wind"
                    },
                    {
                      "keyword": "Then ",
                      "line": 6,
                      "name": "spirit"
                    }
                  ],
                  "type": "scenario"
                },
                {
                  "description": "",
                  "keyword": "Scenario",
                  "line": 9,
                  "id": "oh-hai;-why",
                  "name": "_why",
                  "steps": [
                    {
                      "keyword": "Given ",
                      "line": 10,
                      "name": "chunky"
                    },
                    {
                      "keyword": "Then ",
                      "line": 11,
                      "name": "bacon"
                    }
                  ],
                  "tags": [
                    {
                      "line": 8,
                      "name": "@two"
                    }
                  ],
                  "type": "scenario"
                },
                {
                  "description": "",
                  "examples": [
                    {
                      "description": "",
                      "keyword": "Examples",
                      "line": 18,
                      "id": "oh-hai;life;real-life",
                      "name": "Real life",
                      "rows": [
                        {
                          "id": "oh-hai;life;real-life;1",
                          "cells": [
                            "boredom"
                          ],
                          "line": 19
                        },
                        {
                          "id": "oh-hai;life;real-life;2",
                          "cells": [
                            "airport"
                          ],
                          "line": 20
                        },
                        {
                          "id": "oh-hai;life;real-life;3",
                          "cells": [
                            "meeting"
                          ],
                          "line": 21
                        }
                      ],
                      "tags": [
                        {
                          "line": 17,
                          "name": "@five"
                        }
                      ]
                    }
                  ],
                  "keyword": "Scenario Outline",
                  "line": 14,
                  "id": "oh-hai;life",
                  "name": "Life",
                  "steps": [
                    {
                      "keyword": "Given ",
                      "line": 15,
                      "name": "some <boredom>"
                    }
                  ],
                  "tags": [
                    {
                      "line": 13,
                      "name": "@three"
                    },
                    {
                      "line": 13,
                      "name": "@four"
                    }
                  ],
                  "type": "scenario_outline"
                },
                {
                  "description": "",
                  "keyword": "Scenario",
                  "line": 23,
                  "id": "oh-hai;who-stole-my-mojo?",
                  "name": "who stole my mojo?",
                  "steps": [
                    {
                      "keyword": "When ",
                      "line": 24,
                      "name": "I was",
                      "rows": [
                        {
                          "cells": [
                            "asleep"
                          ],
                          "line": 25
                        }
                      ]
                    },
                    {
                      "doc_string": {
                        "content_type": "plaintext",
                        "line": 27,
                        "value": "innocent"
                      },
                      "keyword": "And ",
                      "line": 26,
                      "name": "so"
                    }
                  ],
                  "type": "scenario"
                },
                {
                  "comments": [
                    {
                      "line": 31,
                      "value": "# The"
                    }
                  ],
                  "description": "",
                  "examples": [
                    {
                      "comments": [
                        {
                          "line": 36,
                          "value": "# comments"
                        },
                        {
                          "line": 37,
                          "value": "# everywhere"
                        }
                      ],
                      "description": "",
                      "keyword": "Examples",
                      "line": 38,
                      "id": "oh-hai;with;an-example",
                      "name": "An example",
                      "rows": [
                        {
                          "id": "oh-hai;with;an-example;1",
                          "cells": [
                            "partout"
                          ],
                          "comments": [
                            {
                              "line": 39,
                              "value": "# I mean"
                            }
                          ],
                          "line": 40
                        }
                      ]
                    }
                  ],
                  "keyword": "Scenario Outline",
                  "line": 32,
                  "id": "oh-hai;with",
                  "name": "with",
                  "steps": [
                    {
                      "comments": [
                        {
                          "line": 33,
                          "value": "# all"
                        }
                      ],
                      "keyword": "Then ",
                      "line": 34,
                      "name": "nice"
                    }
                  ],
                  "type": "scenario_outline"
                }
              ],
              "keyword": "Feature",
              "line": 2,
              "id": "oh-hai",
              "name": "OH HAI",
              "tags": [
                {
                  "line": 1,
                  "name": "@one"
                }
              ]
            }
      }).should == 
  %{@one
Feature: OH HAI

  Scenario: Fujin
    Given wind
    Then spirit

  @two
  Scenario: _why
    Given chunky
    Then bacon

  @three @four
  Scenario Outline: Life
    Given some <boredom>

    @five
    Examples: Real life
      | boredom |
      | airport |
      | meeting |

  Scenario: who stole my mojo?
    When I was
      | asleep |
    And so
      \"\"\"plaintext
      innocent
      \"\"\"

  # The
  Scenario Outline: with
    # all
    Then nice

    # comments
    # everywhere
    Examples: An example
      # I mean
      | partout |}
  end
  
  it "should convert ruby hash of json feature with background to gherkin feature" do
      check_gherkin(%{
    {
              "uri": "test.feature",
              "keyword": "Feature",
              "name": "Kjapp",
              "id": "kjapp",
              "description": "",
              "line": 1,
              "elements": [
                {
                  "type": "background",
                  "keyword": "Background",
                  "line": 3,
                  "name": "No idea what Kjapp means",
                  "description": "",
                  "steps": [
                    {
                      "keyword": "Given ",
                      "line": 4,
                      "name": "I Google it"
                    }
                  ]
                },
                {
                  "type": "scenario",
                  "comments": [{"value": "# Writing JSON by hand sucks", "line": 6}],
                  "keyword": "Scenario",
                  "id": "kjapp;",
                  "name": "",
                  "description": "",
                  "line": 7,
                  "steps": [
                    {
                      "keyword": "Then ",
                      "name": "I think it means \"fast\"",
                      "line": 8
                    }
                  ]
                }
              ]
            }
        }).should ==
%{Feature: Kjapp

    Background: No idea what Kjapp means
      Given I Google it

    # Writing JSON by hand sucks
    Scenario: 
      Then I think it means "fast"}
  end
      
  
end
end
