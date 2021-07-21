package org;

import com.sun.org.apache.xpath.internal.operations.Bool;
import org.xml.sax.SAXException;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;

public class EAD2ArchivesSpace {


    final TransformerFactory tf = TransformerFactory.newInstance();
    @SuppressWarnings("unchecked")
    private ArrayList<Transformer> transformers = new ArrayList(2);
    private static Validate validate;

    private EAD2ArchivesSpace() {

        try {
            validate = new Validate();
        } catch (SAXException e) {
            e.printStackTrace();
        }

//        final String[] _transformers = {
//                "/identity.xsl"
//        };

//        final String[] _transformers = {
//                "/rapport-ar-12.xsl"
//        };

        final String[] _transformers = {
                "/ar-1.xsl",
                "/ar-2.xsl",
                "/ar-3.xsl",
                "/ar-4.xsl",
                "/ar-8.xsl",
                "/ar-11.xsl",
                "/ar-12.xsl",
                "/ar-12-descgrp.xsl", // deze is nodig, want ar-12.xsl maakt anders invalide ead met lege descgrp elementen
                "/ar-13.xsl",
                "/ar-19.xsl",
                "/ar-20.xsl",
                "/ar-21.xsl",
                "/ar-22.xsl", // Deze is lastig, want die maakt invalide ead
                "/ar-22.xsl", // Herhaal, omdat een verwijdert leeg element de ouder ook leeg kan maken
                "/ar-22.xsl", // "
                "/ar-22.xsl", // "
                "/ar-22.xsl", // "
                "/ar-24.xsl",
                "/ar-27.xsl",
                "/ar-29.xsl",
                "/ar-30.xsl",
                "/ar-37.xsl",
                "/ar-38.xsl"
        };

        for (String _transformer : _transformers) {

            final URL resource = this.getClass().getResource(_transformer);
            Source source = null;
            try {
                source = new StreamSource(resource.openStream());
            } catch (IOException e) {
                System.err.println(e.getMessage());
                System.exit(-1);
            }

            source.setSystemId(resource.toString());
            try {
                transformers.add(tf.newTransformer(source));
            } catch (TransformerConfigurationException e) {
                System.err.println(e.getMessage());
                System.exit(-1);
            }
        }

    }

    private void run(String source_folder, String target_folder, boolean validateIt) throws IOException, TransformerException {

        final File[] source_files = new File(source_folder).listFiles((dir, name) -> name.toLowerCase().endsWith(".xml"));
        if (source_files == null) {
            System.out.print("The folder has no files: " + source_folder);
            System.exit(-1);
        }

        final File targetFolder = new File(target_folder);
        if (!targetFolder.exists() && !targetFolder.mkdirs()) {
            System.out.print("Failed to create folder " + target_folder);
            System.exit(-1);
        }

        for (File source_file : source_files) {
            final FileInputStream source = new FileInputStream(source_file);

            final int length = (int) source_file.length();
            byte[] record = new byte[length];
            source.read(record, 0, length);
            final String name = source_file.getName();

            for (Transformer transformer : transformers) {
                record = convertRecord(transformer, record);
            }

            final File target = new File(targetFolder, name);
            final FileOutputStream fos = new FileOutputStream(target);
            fos.write(record);

            if (validateIt) {
                final String msg = validate.validate(target);
                if (msg == null) {
                    // ok
                } else {
                    System.out.println("Invalid EAD xml document: " + target.getAbsolutePath());
                    System.out.println(msg);
                }
            }

            System.out.println("source:" + source_file.getAbsolutePath() + " validate:" + validateIt + " length:" + length + " target:" + target.getAbsolutePath());
        }
    }

    private byte[] convertRecord(Transformer transformer, byte[] record) throws TransformerException {

        final StreamSource source = new StreamSource(new ByteArrayInputStream(record));
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        transformer.transform(source, new StreamResult(baos));
        return baos.toByteArray();
    }

    /**
     * main
     *
     * @param args 0=source folder; 1=destination folder
     */
    public static void main(String[] args) throws IOException, TransformerException {

        final String in = args[0];
        final String out = args[1];
        final boolean validateIt = args.length != 3 || Boolean.parseBoolean(args[2]);

        System.out.println("In " + in);
        System.out.println("Out " + out);
        new EAD2ArchivesSpace().run(in, out, validateIt);
    }
}
