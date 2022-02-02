package org;

import org.xml.sax.SAXException;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import java.io.*;
import java.net.URL;
import java.util.Objects;

public class Validate {

    final Validator validator;
    Transformer transformer;

    public Validate(String _schema) throws SAXException, IOException {

        assert _schema.equalsIgnoreCase("ead") || _schema.equalsIgnoreCase("marc21slim");

        final SchemaFactory factory =
                SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");

        final URL schemaLocation = this.getClass().getResource("/" + _schema + ".xsd");
        final Schema schema = factory.newSchema(schemaLocation);
        validator = schema.newValidator();

        final URL _transformer = this.getClass().getResource("/" + _schema + ".xsl");
        final Source source = new StreamSource(_transformer.openStream());
        source.setSystemId(_transformer.getPath());
        try {
            this.transformer = TransformerFactory.newInstance().newTransformer(source);
        } catch (TransformerConfigurationException e) {
            e.printStackTrace();
        }
    }

    public String validate(File file) {

        final Source source = new StreamSource(file);
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();

        transformer.reset();
        try {
            transformer.transform(source, new StreamResult(baos));
        } catch (TransformerException e) {
            return "BAD: " + e;
        }

        try {
            validator.validate( new StreamSource (new ByteArrayInputStream(baos.toByteArray())));
            return "OK";
        } catch (SAXException ex) {
            return "BAD: " + ex;
        } catch (IOException ex) {
            return "BAD: Could not read file";
        }
    }

    public static void main(String[] args) throws SAXException, TransformerException, IOException {
        assert args.length == 2; // schema en folder

        final Validate validate = new Validate(args[0]);

        final File folder = new File(args[1]);
        assert folder.isDirectory();

        for ( File file : Objects.requireNonNull(folder.listFiles(File::isFile))) {
            final String result = validate.validate(file);
            System.out.println(file.getName() + " " + result);
        };
    }

}