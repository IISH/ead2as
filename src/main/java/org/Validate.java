package org;

import org.xml.sax.SAXException;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import java.io.File;
import java.io.IOException;
import java.net.URL;

public class Validate {

    final Validator validator;

    public Validate() throws SAXException {

        final SchemaFactory factory =
                SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");

        final URL schemaLocation = this.getClass().getResource("/ead.xsd");
        final Schema schema = factory.newSchema(schemaLocation);

        validator = schema.newValidator();
    }

    public String validate(File file) {

        final Source source = new StreamSource(file);

        validator.reset();

        try {
            validator.validate(source);
            return null;
        } catch (SAXException ex) {
            return ex.toString();
        } catch (IOException ex) {
            return "Could not read file " + file;
        }
    }

}