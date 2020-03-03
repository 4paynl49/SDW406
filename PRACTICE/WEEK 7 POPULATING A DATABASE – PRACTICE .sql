--WEEK 7 POPULATING A DATABASE – PRACTICE 

-- Make sure FOREIGN KEY constraints are enabled in SQLite by entering the following command: 
    --PRAGMA foreign_keys = ON; 

--1 
    -- CREATE TABLE unit_types 
    --     (unit_type_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    --     unit_type_name TEXT UNIQUE NOT NULL, 
    --     cat_points INTEGER 
    --     ); 

    -- CREATE TABLE units
    --     (unit_id INTEGER PRIMARY KEY AUTOINCREMENT,
    --     unit_code TEXT UNIQUE NOT NULL,
    --     unit_name TEXT NO NULL,
    --     unit_type_id INTEGER NO NULL, 
    --     CONSTRAINT unit_id_fk FOREIGN KEY (unit_type_id)
    --                             REFERENCES unit_types (unit_type_id)
    --     );

    -- CREATE TABLE courses 
    --     (course_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    --     course_code TEXT UNIQUE NOT NULL, 
    --     course_name TEXT NOT NULL, 
    --     course_level TEXT NOT NULL, 
    --     CONSTRAINT course_level_check CHECK (course_level IN ('MSc','BSc','HND')) 
    -- ); 

    
    -- CREATE TABLE course_units 
    --     (course_id INTEGER, 
    --     unit_id INTEGER, 
    --     CONSTRAINT course_units_pk PRIMARY KEY (course_id, unit_id), 
    --     CONSTRAINT course_id_fk FOREIGN KEY (course_id)  
    --     REFERENCES courses(course_id), 
    --     CONSTRAINT unit_id_fk FOREIGN KEY (unit_id)  
    --     REFERENCES units(unit_id) 
    -- ); 

--2 Use the following command to ALTER the table to add this column
    -- ALTER TABLE courses 
    -- ADD COLUMN course_length INTEGER;

    -- -- Use the following command to ALTER the table
    -- DROP TABLE course_units;
    -- DROP TABLE courses;

    -- CREATE TABLE courses 
    --     (course_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    --     course_code TEXT UNIQUE NOT NULL, 
    --     course_name TEXT NOT NULL, 
    --     course_level TEXT NOT NULL, 
    --     course_length INTEGER NOT NULL, 
    -- CONSTRAINT course_level_check CHECK (course_level IN ('MSc','BSc','HND')), 
    -- CONSTRAINT course_length_check CHECK (course_length between 1 and 4) 
    -- ); 

    -- CREATE TABLE course_units 
    -- (course_id INTEGER, 
    -- unit_id INTEGER, 
    -- CONSTRAINT course_units_pk PRIMARY KEY (course_id, unit_id), 
    -- CONSTRAINT course_id_fk FOREIGN KEY (course_id)  
    -- REFERENCES courses(course_id), 
    -- CONSTRAINT unit_id_fk FOREIGN KEY (unit_id)  
    -- REFERENCES units(unit_id) 
    -- ); 

-- 3 Inserting data 

    -- INSERT INTO unit_types (unit_type_name, cat_points) 
    -- VALUES ('Basic',10); 

    -- INSERT INTO unit_types (unit_type_name, cat_points) 
    -- VALUES ('Intermediate',20); 

    -- INSERT INTO unit_types (unit_type_name, cat_points) 
    -- VALUES ('Advanced',30);


    -- INSERT INTO courses (course_code, course_name, course_level, course_length) 
    -- VALUES ('B74','Comp Science','BSc', 3); 

    -- INSERT INTO courses (course_code, course_name, course_level, course_length) 
    -- VALUES ('B94','Comp Applications','MSc', 2); 

    -- INSERT INTO units (unit_code, unit_name, unit_type_id) 
    -- VALUES ('B741','Program 1',1); 

    -- INSERT INTO units (unit_code, unit_name, unit_type_id) 
    -- VALUES ('B742','Hardware 1',1); 

    -- INSERT INTO units (unit_code, unit_name, unit_type_id) 
    -- VALUES ('B743','Data Processing 1',1); 

    -- INSERT INTO units (unit_code, unit_name, unit_type_id) 
    -- VALUES ('B744','Program 2',2); 

    -- INSERT INTO units (unit_code, unit_name, unit_type_id) 
    -- VALUES ('B745','Hardware 2',2); 

    -- INSERT INTO units (unit_code, unit_name, unit_type_id) 
    -- VALUES ('B951','Information',3); 

    -- INSERT INTO units (unit_code, unit_name, unit_type_id) 
    -- VALUES ('B952','Microprocessors',3); 

    -- INSERT INTO course_units (course_id, unit_id) 
    -- VALUES (1,1);  -- 'B74','B741' 

    -- INSERT INTO course_units (course_id, unit_id) 
    -- VALUES (1,2);  -- 'B74','B742' 

    -- INSERT INTO course_units (course_id, unit_id) 
    -- VALUES (1,3);  -- 'B74','B743' 

    -- INSERT INTO course_units (course_id, unit_id) 
    -- VALUES (1,4);  -- 'B74','B744' 

    -- INSERT INTO course_units (course_id, unit_id) 
    -- VALUES (1,5);  -- 'B74','B745' 

    -- INSERT INTO course_units (course_id, unit_id) 
    -- VALUES (2,6);  -- 'B94','B951' 

    -- INSERT INTO course_units (course_id, unit_id) 
    -- VALUES (2,7);  -- 'B94','B952' 

    -- INSERT INTO course_units (course_id, unit_id) 
    -- VALUES (2,1);  -- 'B94','B741' ]

-- 4 Updating and deleting data 
    -- UPDATE units 
    -- SET unit_name = 'Programming 1' 
    -- WHERE unit_code = 'B741'; 

    -- UPDATE units 
    -- SET unit_name = 'Programming 2' 
    -- WHERE unit_code = 'B744'; 

    -- UPDATE courses 
    -- SET course_name = 'Computer '||SUBSTR(course_name,6,LENGTH(course_name)-5) 
    -- WHERE course_name like 'Comp%'; 

    -- DELETE FROM course_units 
    -- WHERE unit_id = (SELECT unit_id  
    -- FROM units  
    -- WHERE unit_name = 'Hardware 2'); 

    -- DELETE FROM units 
    -- WHERE unit_name = 'Hardware 2'; 


