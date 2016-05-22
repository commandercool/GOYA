create table file (
 id bigserial not null primary key,
 parent_id bigint,
 name varchar(255) not null,
 description varchar(255) not null,
 type_id bigint not null,
 acl_id bigint not null,
 modifier bigint not null,
 modification_date date not null,
 creator bigint not null,
 creation_date date not null
);

create table folder (
 id bigint not null primary key
);

alter table folder add constraint folder_from_file foreign key (id) references file (id);
alter table file add constraint parent_folder foreign key (parent_id) references folder(id);

create table shortcut (
 id bigint not null primary key,
 file_id bigint not null
);

alter table shortcut add constraint shortcut_from_file foreign key (id) references file (id);
alter table shortcut add constraint shortcut_to_file foreign key (file_id) references file(id);

create table document (
 id bigint not null primary key,
 content_id bigint,
 major_number integer not null,
 minor_number integer not null
);

alter table document add constraint document_from_file foreign key (id) references file (id);

create table content (
 id bigserial not null primary key
);

alter table document add constraint document_content foreign key (content_id) references content (id);

create table representation (
 id bigserial not null primary key,
 content_id bigint not null,
 mime_type varchar(100)
);

alter table representation add constraint representation_content foreign key (content_id) references content (id);

create table document_link (
 from_id bigint not null,
 to_id bigint not null,
 primary key (from_id, to_id)
);

alter table document_link add constraint document_link_from foreign key (from_id) references document (id);
alter table document_link add constraint document_link_to foreign key (to_id) references document (id);

create table version (
 id bigserial not null primary key,
 name varchar(255) not null,
 description varchar(255),
 document_id bigint not null,
 content_id bigint not null,
 major_number integer not null,
 minor_number integer not null
);

alter table version add constraint version_document foreign key (document_id) references document (id);
alter table version add constraint version_content foreign key (content_id) references content (id);

create table type (
 id bigserial not null primary key,
 name varchar(255),
 parent_type_id bigint
);

alter table type add constraint type_parent foreign key (parent_type_id) references type (id);

create table attribute (
 id bigserial not null primary key,
 name varchar(255) not null,
 type_id bigint not null,
 data_type varchar(50)
);

alter table attribute add constraint attribute_type foreign key (type_id) references type (id);

create table data_type (
 data_type_name varchar(50) not null primary key
);

alter table attribute add constraint attribute_data_type foreign key (data_type) references data_type (data_type_name);

create table attribute_params (
 attribute_id bigint not null,
 type_id bigint not null,
 lifecycle_id bigint not null,
 p_key varchar(255) not null,
 p_value varchar(255) not null,
 primary key (attribute_id, type_id, lifecycle_id, p_key)
);

alter table attribute_params add constraint attribute_param_attribute foreign key (attribute_id) references attribute (id);
alter table attribute_params add constraint attribute_param_type foreign key (type_id) references type (id);

create table acl (
 id bigserial not null primary key
);

alter table file add constraint file_acl foreign key (acl_id) references acl (id);

create table permission (
 id bigserial not null primary key,
 acl_id bigint not null,
 identity_id bigint not null,
 p_right varchar(50) not null,
 is_implicit boolean not null
);

alter table permission add constraint premission_acl foreign key (acl_id) references acl (id);

create table p_right (
 right_name varchar(50) not null primary key
);

alter table permission add constraint permission_right foreign key (p_right) references p_right (right_name);

create table identity (
 id bigserial not null primary key,
 name varchar(255) not null
);

create table i_user (
 id bigint not null primary key
);

alter table i_user add constraint user_from_identtiy foreign key (id) references identity (id);

create table i_group (
 id bigint not null primary key
);

alter table i_group add constraint group_from_identity foreign key (id) references identity (id);

create table identity_in_group (
 identity_id bigint not null,
 group_id bigint not null,
 primary key (identity_id, group_id)
);

alter table identity_in_group add constraint grouped_identity foreign key (identity_id) references identity (id);
alter table identity_in_group add constraint grouped_group foreign key (group_id) references i_group (id);

create table locale (
 id varchar(255) not null primary key,
 label varchar(255) not null
);